-- TODO: the <leader>; shortcut can be upgraded to open the sidebar window always as a "top level" vertical split to the right.
-- and not vertical split relative to the current window
local oil_winid = nil
local config_oil = {
  'stevearc/oil.nvim',
  opts = {
    columns = {
      'icon',
    },
    view_options = {
      show_hidden = true,
    },
    skip_confirm_for_simple_edits = true,
    win_options = {
      winbar = "%{v:lua.require('oil').get_current_dir()}",
    },
    keymaps = {
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<CR>'] = {
        callback = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          if not entry then return end
          if entry.type == 'directory' then
            require('oil.actions').select.callback()
            return
          end

          if vim.api.nvim_get_current_win() == oil_winid then
            -- in sidebar oil buf
            local dir = oil.get_current_dir()
            local filepath = dir .. entry.parsed_name
            vim.cmd('wincmd p')
            vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
            return
          end

          -- "normal" oil buf
          require('oil.actions').select.callback()
        end,
        desc = 'Open file in previous window'
      },
    }
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
  keys = {
    {
      '<leader>o',
      function()
        -- NOTE: unfort this doesn't actually work. oil seems to only take exactly 1 columns config and use that for all oil calls.
        require('oil').open(nil, {
          columns = {
            'icon',
            'permissions',
            'size',
            'mtime',
          }
        })
      end,
      desc = 'Open Oil with main config.',
    },
    {
      '<leader>;',
      function()
        if oil_winid and vim.api.nvim_win_is_valid(oil_winid) then
          vim.api.nvim_win_close(oil_winid, false)
          oil_winid = nil
        else
          vim.cmd('rightbelow vsplit')

          vim.cmd('vertical resize 60')

          require('oil').open(nil, {
            columns = { 'icon' },
          })

          oil_winid = vim.api.nvim_get_current_win()
        end
      end,
      desc = 'Toggle Oil in vertical split',
    },
  },
}

return config_oil
