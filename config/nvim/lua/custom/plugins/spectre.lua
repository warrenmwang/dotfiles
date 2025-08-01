return {
  'nvim-pack/nvim-spectre',
  config = function()
    require('spectre').setup()
  end,
  lazy = true,
  keys = {
    { '<leader>sr', '<cmd>Spectre<CR>', { desc = '[S]earch and [R]eplace across Files', noremap = true, silent = true } },
  },
}
