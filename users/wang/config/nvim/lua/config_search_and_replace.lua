local config_search_and_replace = {
  'nvim-pack/nvim-spectre',
  init = function()
    vim.keymap.set('v', '<A-f>',
      function()
        vim.cmd('normal! y')
        require('spectre').open_visual()
      end
    )
  end,
  opts = {
    highlight = {
      ui = "String",
      search = "Search",
      replace = "IncSearch"
    },
    find_engine = {
      ['rg'] = {
        cmd = "rg",
        args = {
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--fixed-strings',
        },
        options = {
          ['ignore-case'] = {
            value = "--ignore-case",
            icon = "[I]",
            desc = "ignore case"
          },
          ['hidden'] = {
            value = "--hidden",
            icon = "[H]",
            desc = "hidden file"
          },
          ['regex'] = {
            value = "--regexp",
            icon = "[R]",
            desc = "regex"
          },
        }
      },
    },
    default = {
      find = {
        cmd = "rg",
        options = {}
      },
    },
    mapping = {
      ['toggle_regex'] = {
        map = '<leader>tr',
        cmd = "<cmd>lua require('spectre').change_options('regex')<CR>",
        desc = "toggle regex"
      },
    },
  },
  lazy = true,
  keys = {
    { '<leader>sr', '<cmd>Spectre<CR>', { desc = '[S]earch and [R]eplace across Files', noremap = true, silent = true } },
  },
}

return config_search_and_replace
