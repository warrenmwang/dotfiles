-- Kickstarter notes
-- See `:help mapleader`
-- See `:help vim.opt`, see `:help option-list`
-- See `:help gitsigns` to understand what the configuration keys do
-- Use `opts = {}` to force a plugin to be loaded.
-- lazy :help lazy.nvim-lazy.nvim-structuring-your-plugins
-- [[ Configure and install plugins ]]
--  To check the current status of your plugins, run
--    :Lazy
--  You can press `?` in this menu for help. Use `:q` to close the window
--  To update plugins you can run
--    :Lazy update

if vim.fn.has 'win32' == 1 then
  vim.opt.shell = 'powershell.exe'
  vim.opt.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  vim.opt.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
end

-- space as leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true -- Curr Pref: [Cousine Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Cousine.zip)

-- allow moving text selected in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'H', 'xhhp`[v`]')
vim.keymap.set('v', 'L', 'xp`[v`]')

-- search and replace with spectre
vim.keymap.set('n', '<leader>sr', '<cmd>lua require("spectre").open()<CR>', { desc = '[S]earch and [R]eplace across Files', noremap = true, silent = true })

vim.keymap.set('n', 'gc', ':Commentary')
vim.keymap.set('v', 'gc', ':Commentary')

-- set tab to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- autocommand group and definition for 2 spaces tab for web dev files (html, css, js, ts, jsx, tsx)
vim.api.nvim_create_augroup('SetTabWidth', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'SetTabWidth',
  pattern = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})

-- Make line numbers default
vim.opt.number = true
-- Relative line numbers, to help with jumping.
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- vim.opt.listchars = { trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>ql', vim.diagnostic.setloclist, { desc = 'Open Diagnostic [Q]uickfix [L]ist' })
vim.keymap.set('n', '<leader>qn', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to Diagnostic [Q]uickfix [N]ext' })
vim.keymap.set('n', '<leader>qp', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to Diagnostic [Q]uickfix [P]revious' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode -- lol
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- window mappings to enable expanding and shrinking window sizes with
-- leader + movement keys
vim.keymap.set('n', '<leader>h', '<cmd>vertical resize -5<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<leader>l', '<cmd>vertical resize +5<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<leader>k', '<cmd>resize +5<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<leader>j', '<cmd>resize -5<CR>', { desc = 'Decrease window height' })

-- [[ Misc function stuff... ]]

-- Set the correct filetype for docker compose yamls, to trigger LSP attachment.
-- https://vi.stackexchange.com/a/44948
local function set_filetype(pattern, filetype)
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = pattern,
    command = 'set filetype=' .. filetype,
  })
end

set_filetype({ 'docker-compose.yml' }, 'yaml.docker-compose')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  -- core plugins
  require 'core.plugins.lsp-stuff',
  require 'core.plugins.telescope',
  require 'core.plugins.treesitter',
  require 'core.plugins.git-stuff',
  require 'core.plugins.comment',

  -- kickstart plugins
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.mini',
  -- require 'kickstart.plugins.which-key',

  -- custom/misc plugins
  require 'custom.plugins.barbar',
  require 'custom.plugins.colors',
  require 'custom.plugins.oil',
  require 'custom.plugins.vim-visual-multi',
  require 'custom.plugins.spectre',

  require 'custom.plugins.markdown-preview',
  require 'custom.plugins.autotags',
  require 'custom.plugins.typescript-tools',
  require 'custom.plugins.tailwind-tools',

  -- require 'custom.plugins.avante',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
