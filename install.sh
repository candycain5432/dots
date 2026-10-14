#!/usr/bin/env bash
# install.sh - link these dots into $HOME with GNU Stow
#
#   ./install.sh               link every package
#   ./install.sh hypr kitty    link only the named packages
#   ./install.sh --packages    install packages/pacman.txt + packages/aur.txt first
#
# Anything already in the way is moved to ~/.dots-backup/<timestamp>/, never deleted.
set -euo pipefail

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dots-backup/$(date +%Y%m%d-%H%M%S)"

install_packages=false
pkgs=()
for arg in "$@"; do
    case "$arg" in
        --packages) install_packages=true ;;
        -h|--help)  sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *)          pkgs+=("${arg%/}") ;;
    esac
done

if $install_packages; then
    sudo pacman -S --needed - < "$DOTS/packages/pacman.txt"
    if   command -v paru >/dev/null; then paru -S --needed - < "$DOTS/packages/aur.txt"
    elif command -v yay  >/dev/null; then yay  -S --needed - < "$DOTS/packages/aur.txt"
    else echo "no AUR helper (paru/yay) found, skipping packages/aur.txt" >&2
    fi
fi

command -v stow >/dev/null || sudo pacman -S --needed stow

if [ ${#pkgs[@]} -eq 0 ]; then
    for d in "$DOTS"/*/; do
        d="$(basename "$d")"
        case "$d" in extras|packages) continue ;; esac
        pkgs+=("$d")
    done
fi

backup() {
    local rel="${1#"$HOME/"}"
    mkdir -p "$BACKUP/$(dirname "$rel")"
    mv "$1" "$BACKUP/$rel"
    echo "  backed up ~/$rel"
}

# Walk each file's path down from $HOME and move aside the first thing that
# would block stow: a real file, or a symlink that points somewhere else
# (e.g. ~/.config/nvim -> ~/old-dotfiles/...). Moving the link itself means
# whatever it pointed at is left untouched.
for p in "${pkgs[@]}"; do
    [ -d "$DOTS/$p" ] || { echo "no such package: $p" >&2; exit 1; }
    while IFS= read -r -d '' f; do
        rel="${f#"$DOTS/$p/"}"
        path="$HOME"
        IFS=/ read -ra parts <<< "$rel"
        for i in "${!parts[@]}"; do
            path="$path/${parts[$i]}"
            last=$(( i == ${#parts[@]} - 1 ))
            if [ -L "$path" ]; then
                case "$(readlink -f "$path")" in "$DOTS"/*) ;; *) backup "$path" ;; esac
                break
            elif [ -e "$path" ] && { [ "$last" = 1 ] || [ ! -d "$path" ]; }; then
                backup "$path"
                break
            elif [ ! -e "$path" ]; then
                break
            fi
        done
    done < <(find "$DOTS/$p" -type f -print0)
done

# --no-folding links files, not whole directories, so anything an app writes
# next to its config stays out of this repo.
stow --no-folding -d "$DOTS" -t "$HOME" -R "${pkgs[@]}"

echo
echo "linked: ${pkgs[*]}"
[ -d "$BACKUP" ] && echo "old files are in $BACKUP"
cat <<'EOF'

not handled here:
  - impasto's system side (SDDM theme, Hyprland plugins, stock wallpapers): run its ./setup
  - spicetify:  spicetify config current_theme impasto && spicetify apply
  - zen:        copy extras/zen/userChrome.css into <zen profile>/chrome/
EOF
