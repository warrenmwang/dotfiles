-- https://github.com/pmizio/typescript-tools.nvim
-- REPLACES typescript-language-server! (so don't install
-- using Mason if using this instead)
return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {},
}
