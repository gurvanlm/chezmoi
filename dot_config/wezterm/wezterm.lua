local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Force XWayland to get native window decorations (title bar, move, resize)
-- Native Wayland mode doesn't support server-side decorations on GNOME
config.enable_wayland = false
config.window_decorations = "TITLE|RESIZE"

-- Theme
config.color_scheme = 'Tokyo Night'

-- Hide tab bar
config.enable_tab_bar = false

return config
