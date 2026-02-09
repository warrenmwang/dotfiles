local config_pair = {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {
        disable_filetype = { 'TelescopePrompt', 'vim' },
      }
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    -- auto close and auto rename html tags
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup {
        filetypes = {
          'html',
          'xml',
          'markdown',
          'javascriptreact',
          'typescriptreact',
        },
      }
    end,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    lazy = true,
    ft = WebFileTypes,
  },
}

return config_pair
