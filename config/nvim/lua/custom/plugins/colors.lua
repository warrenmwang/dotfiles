return {
  {
    -- Main ColorScheme
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      vim.cmd.termguicolors = true
      vim.opt.background = 'light'
      vim.cmd.colorscheme 'tokyonight-moon'
      vim.cmd.hi 'Comment gui=none' -- highlights
    end,
  },
  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'background',
      virtual_symbol = '■',
      virtual_symbol_prefix = '',
      virtual_symbol_suffix = ' ',
      virtual_symbol_position = 'inline',
      enable_hex = true,
      enable_short_hex = true,
      enable_rgb = true,
      enable_hsl = true,
      enable_var_usage = true,
      enable_named_colors = true,
      enable_tailwind = false,
      custom_colors = {
        { label = '%-%-theme%-primary%-color', color = '#0f1219' },
        { label = '%-%-theme%-secondary%-color', color = '#5a5d64' },
      },
      exclude_filetypes = {},
      exclude_buftypes = {},
    },
  },
  {
    -- Highlight todo, notes, etc in comments
    -- TODO: what a todo looks like
    -- NOTE: what a note looks like
    -- FIX: what a fix looks like
    -- BUG: this is what a bug looks like
    -- HACK: this is what a hack looks like
    -- WARNING: ruh roh
    -- PERF: optimize this
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false, -- show icons in the signs column
      highlight = {
        keyword = 'bg', -- only highlight the keyword, default: 'wide'
        after = '', -- don't highlight the words after, just the keyword
        pattern = [[.*<(KEYWORDS)\s*]], -- set a pattern without the ':', default is: [[.*<(KEYWORDS)\s*:]]
      },
    },
  },
}
