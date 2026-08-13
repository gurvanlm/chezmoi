local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Force XWayland to get native window decorations (title bar, move, resize)
-- Native Wayland mode doesn't support server-side decorations on GNOME
config.enable_wayland = false
config.window_decorations = "TITLE|RESIZE"

-- Theme
config.color_scheme = 'Tokyo Night'

-- Font
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 11
config.line_height = 1.1

-- Window
config.window_padding = {
    left = 8,
    right = 8,
    top = 4,
    bottom = 4,
}

-- No bell
config.audible_bell = 'Disabled'

-- Hide tab bar
config.enable_tab_bar = false

-- Keybindings
config.keys = {
    -- Shift+Enter sends a real newline (for Claude Code multiline input)
    { key = 'Enter', mods = 'SHIFT', action = wezterm.action.SendString('\n') },

    -- Ctrl+Shift+Escape : ferme un popup tmux bloqué.
    -- Les touches d'un popup vont à son process, pas à tmux : si celui-ci
    -- cesse de lire l'entrée, aucun raccourci tmux ne peut le fermer. WezTerm,
    -- lui, intercepte le raccourci avant tmux — d'où le binding ici.
    {
        key = 'Escape',
        mods = 'CTRL|SHIFT',
        action = wezterm.action_callback(function()
            wezterm.background_child_process({
                wezterm.home_dir .. '/.local/bin/tmux-popup-close',
            })
        end),
    },
}

return config
