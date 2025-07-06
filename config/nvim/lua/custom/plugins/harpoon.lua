return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    vim.keymap.set('n', '<A-p>', function()
      harpoon:list():add()
    end, { desc = 'Harpoon: Add current file' })

    vim.keymap.set('n', '<A-h>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Toggle Quick Menu' })

    vim.keymap.set('n', '<A-1>', function()
      harpoon:list():select(1)
    end, { desc = 'Harpoon: Jump to item 1' })

    vim.keymap.set('n', '<A-2>', function()
      harpoon:list():select(2)
    end, { desc = 'Harpoon: Jump to item 2' })

    vim.keymap.set('n', '<A-3>', function()
      harpoon:list():select(3)
    end, { desc = 'Harpoon: Jump to item 3' })

    vim.keymap.set('n', '<A-4>', function()
      harpoon:list():select(4)
    end, { desc = 'Harpoon: Jump to item 4' })

    vim.keymap.set('n', '<A-5>', function()
      harpoon:list():select(5)
    end, { desc = 'Harpoon: Jump to item 5' })

    vim.keymap.set('n', '<A-6>', function()
      harpoon:list():select(6)
    end, { desc = 'Harpoon: Jump to item 6' })

    vim.keymap.set('n', '<A-7>', function()
      harpoon:list():select(7)
    end, { desc = 'Harpoon: Jump to item 7' })

    vim.keymap.set('n', '<A-8>', function()
      harpoon:list():select(8)
    end, { desc = 'Harpoon: Jump to item 8' })

    vim.keymap.set('n', '<A-9>', function()
      harpoon:list():select(9)
    end, { desc = 'Harpoon: Jump to item 9' })

    vim.keymap.set('n', '<A-0>', function()
      harpoon:list():select(10)
    end, { desc = 'Harpoon: Jump to item 10' })
  end,
}
