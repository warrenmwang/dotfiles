return {
  -- plugin for <leader>sr which opens a small ui that lets you search and replace
  -- text across the current project
  'nvim-pack/nvim-spectre',
  config = function()
    require('spectre').setup()
  end,
}
