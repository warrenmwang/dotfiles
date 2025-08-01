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
      ---Render style
      ---@usage 'background'|'foreground'|'virtual'
      render = 'background',

      ---Set virtual symbol (requires render to be set to 'virtual')
      virtual_symbol = '■',

      ---Set virtual symbol suffix (defaults to '')
      virtual_symbol_prefix = '',

      ---Set virtual symbol suffix (defaults to ' ')
      virtual_symbol_suffix = ' ',

      ---Set virtual symbol position()
      ---@usage 'inline'|'eol'|'eow'
      ---inline mimics VS Code style
      ---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
      ---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
      virtual_symbol_position = 'inline',

      ---Highlight hex colors, e.g. '#FFFFFF'
      enable_hex = true,

      ---Highlight short hex colors e.g. '#fff'
      enable_short_hex = true,

      ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
      enable_rgb = true,

      ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
      enable_hsl = true,

      ---Highlight CSS variables, e.g. 'var(--testing-color)'
      enable_var_usage = true,

      ---Highlight named colors, e.g. 'green'
      enable_named_colors = true,

      ---Highlight tailwind colors, e.g. 'bg-blue-500'
      enable_tailwind = false,

      ---Set custom colors
      ---Label must be properly escaped with '%' to adhere to `string.gmatch`
      --- :help string.gmatch
      custom_colors = {
        { label = '%-%-theme%-primary%-color', color = '#0f1219' },
        { label = '%-%-theme%-secondary%-color', color = '#5a5d64' },
      },

      -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
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
