local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 16.0
config.font = wezterm.font_with_fallback {
    {family="Monaspace Neon", weight="Bold"},
}
config.use_fancy_tab_bar = false
config.color_scheme = "tokyonight"

config.audible_bell = "Disabled"

return config
