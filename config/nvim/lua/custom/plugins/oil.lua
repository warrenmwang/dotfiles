return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    view_options = {
      show_hidden = true,
    },
    skip_confirm_for_simple_edits = true,
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  lazy = false,
  keys = {
    { '<leader>o', '<cmd>Oil<CR>' },
  },
}
