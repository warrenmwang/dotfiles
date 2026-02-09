local config_treesitter = {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    -- ensure_installed = {
    --   'lua',
    --   'luadoc',
    -- },
    -- ensure_installed = {
    --   'c',
    --   'bash',
    --   'diff',
    --   'html',
    --   'css',
    --   'lua',
    --   'luadoc',
    --   'astro',
    --   'markdown',
    --   'markdown_inline',
    --   'query',
    --   'vim',
    --   'vimdoc',
    --   'python',
    --   'go',
    --   'java',
    --   'javascript',
    --   'typescript',
    --   'tsx',
    -- },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  config = function(_, opts)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    vim.treesitter.language.register('tsx', 'typescriptreact')

    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)
  end,
}

return config_treesitter
