local wezterm = require("wezterm")
local colors = require("colors")
local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true
config.automatically_reload_config = true

config.default_prog = { "/usr/bin/nu" }
config.font = wezterm.font({
    family = "JetbrainsMono Nerd Font",
    weight = "Medium",
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 9.5

config.color_scheme = "Catppuccin Mocha"
config.enable_wayland = false
config.enable_kitty_keyboard = true

config.colors = {
    cursor_bg = colors.primary,
    cursor_fg = colors.on_primary,
    cursor_border = colors.outline,
    foreground = colors.on_background,
    background = colors.background,
    selection_fg = colors.on_primary,
    selection_bg = colors.primary,
}

return config
