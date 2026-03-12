local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.font = wezterm.font 'Cousine Nerd Font Mono'
config.font_size = 14

-- True colour / terminal
config.term = "xterm-256color"

-- No escape time lag (good for neovim)
config.enable_wayland = false  -- windows, so irrelevant, but just in case
-- WezTerm has essentially 0 escape-time by default, nothing to set

-- Focus events for neovim
-- config.enable_focus_follows_mouse = false  -- personal taste

-- Status bar styling (mimicking black bg, white fg, minimal right)
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.colors = {
  tab_bar = {
    background = '#000000',
    active_tab = {
      bg_color = '#ffffff',
      fg_color = '#000000',
    },
    inactive_tab = {
      
      bg_color = '#000000',
      fg_color = '#ffffff',
    },
    inactive_tab_hover = {
      
      bg_color = '#222222',
      fg_color = '#ffffff',
    },
  },
}

-- Tab title format mimicking <WindowName:Index>
-- WezTerm uses a callback for this
-- wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
--   local cwd = tab.active_pane:get_current_working_directory()
--   local name = 'Terminal'
--   if cwd then
--     for part in string.gmatch(cwd, "[^/\\]+") do
--       name = part
--     end
--   end
--   return ' ' .. name .. ' '
-- end)

local keys = {
  -- Splits
  { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },

  -- Vim motions to move between panes
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left'  },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down'  },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up'    },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- Resize panes with Ctrl+hjkl (held, repeatable)
  { key = 'h', mods = 'CTRL', action = act.AdjustPaneSize { 'Left',  5 } },
  { key = 'j', mods = 'CTRL', action = act.AdjustPaneSize { 'Down',  5 } },
  { key = 'k', mods = 'CTRL', action = act.AdjustPaneSize { 'Up',    5 } },
  { key = 'l', mods = 'CTRL', action = act.AdjustPaneSize { 'Right', 5 } },

  -- Copy mode (like tmux copy mode)
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },

  -- Paste from clipboard (like your ']' bind)
  { key = ']', mods = 'LEADER', action = act.PasteFrom 'Clipboard' },

  -- Reload config
  { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },
}

config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
keys = keys

-- Add Ctrl+Space+Num bindings for tab switching
for i = 1, 9 do
  table.insert(keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

table.insert(keys, { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) })
table.insert(keys, { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) })

table.insert(keys, { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' })
table.insert(keys, { key = 'w', mods = 'LEADER', action = act.CloseCurrentTab { confirm = true } })

config.keys = keys

-- Vi mode keybinds in copy mode
config.key_tables = {
  copy_mode = {
    -- Movement
    { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft'  },
    { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown'  },
    { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp'    },
    { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord'  },
    { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
    { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine'      },
    { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
    { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
    { key = 'g', mods = 'CTRL', action = act.CopyMode 'MoveToScrollbackTop'    },

    -- Selection
    { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
    { key = 'V', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Line' } },

    -- Yank to clipboard and exit
    { key = 'y', mods = 'NONE', action = act.Multiple {
        act.CopyTo 'Clipboard',
        act.CopyMode 'Close',
      }
    },

    -- Page up/down
    { key = 'd', mods = 'CTRL', action = act.CopyMode 'PageDown' },
    { key = 'u', mods = 'CTRL', action = act.CopyMode 'PageUp' },

    -- Exit copy mode
    { key = 'q',      mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
  },
}

return config
