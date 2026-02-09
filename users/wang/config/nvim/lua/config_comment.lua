local config_comment =
{
  -- {
  --   'tpope/vim-commentary',
  --   keys = {
  --     { '<C-/>',    ':Commentary<CR>' },
  --     { mode = 'v', '<C-/>',          ':Commentary<CR>' },
  --   },
  -- },
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    opts = {
      -- add any options here
    },
    config = function(_, opts)
      if IN_GUI then
        vim.keymap.set('n', '<C-/>', '<Plug>(comment_toggle_linewise_current)', { desc = 'Toggle line comment' })
        vim.keymap.set('v', '<C-/>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle line comment' })
      else
        vim.keymap.set('n', '<A-/>', '<Plug>(comment_toggle_linewise_current)', { desc = 'Toggle line comment' })
        vim.keymap.set('v', '<A-/>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle line comment' })
      end
    end
  }
}

return config_comment
