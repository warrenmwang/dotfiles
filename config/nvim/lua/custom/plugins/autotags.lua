return {
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
}
