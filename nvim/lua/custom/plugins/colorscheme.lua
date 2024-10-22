-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--
-- regular comment
-- TODO: what a todo looks like
-- NOTE: what a note looks like
-- FIXME: what a fixme looks like
--

-- return {
--   'savq/melange-nvim',
--   priority = 1000, -- Make sure to load this before all the other start plugins.
--   init = function()
--     vim.cmd.termguicolors = true
--     vim.opt.background = 'light'
--     vim.cmd.colorscheme 'melange'
--     -- Additional config for colors
--     vim.cmd.hi 'Comment gui=none' -- highlights
--   end,
-- }

-- return {
--   'catppuccin/nvim',
--   name = 'catppuccin',
--   priority = 1000,
--   init = function()
--     vim.termguicolors = true
--     vim.cmd.colorscheme 'catppuccin-macchiato'
--   end,
-- }

return {
  'folke/tokyonight.nvim',
  priority = 1000,
  init = function()
    vim.cmd.termguicolors = true
    vim.opt.background = 'light'
    -- vim.cmd.colorscheme 'delek'
    vim.cmd.colorscheme 'tokyonight-moon'
    vim.cmd.hi 'Comment gui=none' -- highlights
  end,
}
