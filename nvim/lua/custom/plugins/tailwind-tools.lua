-- tailwind-tools.lua
-- requires tailwindcss-language-server (install using Mason)
return {
  'luckasRanarison/tailwind-tools.nvim',
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    'neovim/nvim-lspconfig',
  },
  opts = {}, -- your configuration
  lazy = true,
  ft = WebFileTypes,
}
