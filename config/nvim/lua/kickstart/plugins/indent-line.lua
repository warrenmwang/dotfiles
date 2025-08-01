return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      scope = { enabled = false }, -- set to true to enable highlighting of the current scope (requires tree-sitter)
    },
  },
}
