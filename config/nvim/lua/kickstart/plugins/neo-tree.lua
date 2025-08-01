return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>;', ':Neotree toggle right<CR>', desc = 'NeoTree toggle' },
  },
  lazy = false, -- according to the github, neo-tree will lazily load itself...
  opts = {
    filesystem = {
      hijack_netrw_behavior = 'disabled',
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
