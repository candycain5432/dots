-- mine.lua - my own rules, kept out of impasto's module files
-- Opacity numbers: focused, unfocused, fullscreen ("override" = use exactly this)

hl.window_rule({
    name    = "zen-glass",
    match   = { class = "^zen$" },
    opacity = "0.90 override 0.82 override 1.0 override",
})
