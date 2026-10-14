# Dots

![alt text](Impasto.png "Impasto")
![alt text](Impasto1.png "Impasto")

My Arch Linux rice: **Hyprland** (Lua config) + **Quickshell**, built on top of
[impasto](https://github.com/andreumassanet/impasto). The whole desktop
repaints itself from whatever wallpaper is up.

| | |
|---|---|
| **OS** | Arch Linux |
| **WM** | Hyprland, configured in Lua |
| **Bar / dock / notifications / lock** | Quickshell (impasto) |
| **Wallpaper daemon** | awww |
| **Terminal** | kitty, JetBrainsMono Nerd Font |
| **Shell** | zsh + starship |
| **Editor** | Neovim (NvChad, `crimson_temple` theme), VSCodium |
| **Files** | Thunar, yazi |
| **Visualizer / monitor** | cava, btop |
| **Theming** | GTK 3/4, qt6ct, kdeglobals, spicetify, Vesktop, Zen |

## Credits

Most of the desktop is [impasto](https://github.com/andreumassanet/impasto) by
andreumassanet, released under GPL-3.0. Because this repo includes and modifies
impasto's files, it is also released under GPL-3.0 (see [LICENSE](LICENSE)). The
GrapeNuts font is OFL (license next to it in `impasto/.local/share/fonts/`), and
the cava shaders carry their authors' own notices.

My own additions on top of impasto:

- `hypr/.config/hypr/modules/mine.lua`: my window rules (glassy Zen browser)
- `hypr/.config/hypr/palette.lua`: the Crimson Temple palette
- Crimson Temple themes for btop and spicetify, plus cava shaders
- VSCodium settings, the NvChad config, GTK/Qt overrides, Thunar custom actions

## Install

The rice needs impasto's system side first (SDDM theme, Hyprland plugins, stock
wallpapers), which lives outside `$HOME`:

```sh
git clone https://github.com/andreumassanet/impasto && cd impasto && ./setup
```

Then link these configs over it:

```sh
git clone https://github.com/candycain5432/dots ~/dots
cd ~/dots
./install.sh               # link everything
./install.sh hypr kitty    # or just some packages
./install.sh --packages    # also install my pacman + AUR package lists
```

`install.sh` uses [GNU Stow](https://www.gnu.org/software/stow/). Anything already
at a target path is moved to `~/.dots-backup/<timestamp>/`, never deleted.

After that:

- **Spotify:** `spicetify config current_theme impasto && spicetify apply`
- **Zen:** copy `extras/zen/userChrome.css` into `<your zen profile>/chrome/`
- **Not named william?** Fix the hardcoded home path in
  `qt/.config/qt6ct/qt6ct.conf` and `gtk/.gtkrc-2.0`.

## Layout

Each top-level folder is a Stow package that mirrors `$HOME`:

```
hypr/        .config/hypr          Hyprland (Lua), hypridle, hyprlock
quickshell/  .config/quickshell    bar, dock, island, desktop widgets, lock
kitty/ zsh/ starship/ nvim/        terminal, shell, prompt, editor
btop/ cava/ fastfetch/ yazi/ imv/ glow/
gtk/ qt/                           GTK 2/3/4, nwg-look, xsettingsd, qt6ct, kdeglobals
thunar/ spicetify/ vesktop/ vscodium/
impasto/     .local/share          impasto palettes/profiles, GrapeNuts font
wallpapers/  Pictures/wallpapers
waybar/ rofi/ mako/ wlogout/ nwg/  from my earlier Crimson Temple setup, not autostarted
packages/    pacman.txt, aur.txt   explicitly installed packages
extras/      files that can't be stowed (Zen profile CSS)
```

## Heads up

impasto's theme manager rewrites a lot of these files every time the wallpaper
changes (kitty's `current-theme.conf`, the `impasto` themes for btop, cava, yazi,
qt6ct, spicetify and Vesktop, `kdeglobals`, the GTK CSS). Expect `git status`
to show changes after a wallpaper switch. Commit them if you want to keep that
look.
