local wezterm = require("wezterm")
local colors = require("colors")
local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true
config.automatically_reload_config = true

config.default_prog = { "/usr/bin/nu" }
config.font = wezterm.font({
    family = "JetbrainsMono Nerd Font",
    weight = "Medium",
    harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
})
config.font_size = 9.5

config.color_scheme = "Catppuccin Mocha"
config.enable_wayland = false
config.enable_kitty_keyboard = true
config.enable_kitty_graphics = true

config.freetype_load_flags = "NO_HINTING|NO_AUTOHINT"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.anti_alias_custom_block_glyphs = true

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
