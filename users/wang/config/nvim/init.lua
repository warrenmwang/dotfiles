-- Kickstarter notes
-- See `:help mapleader`
-- See `:help vim.opt`, see `:help option-list`
-- See `:help gitsigns` to understand what the configuration keys do
-- Use `opts = {}` to force a plugin to be loaded.
-- See `:help telescope` and `:help telescope.setup()`
-- :Lazy
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
--  See `:help lua-guide-autocommands`

-- Globals
IN_GUI = vim.fn.has 'gui_running' == 1
DEBUG = false
ON_WINDOWS_OS = vim.fn.has 'win32' == 1
ON_LINUX_NIXOS = vim.fn.has 'unix' == 1 and vim.fn.executable('nixos-rebuild') == 1
ON_LINUX_NORMAL_OS = vim.fn.has 'unix' == 1 and not ON_WINDOWS_OS and not ON_LINUX_NIXOS
USE_MASON = false
if DEBUG then
  print("OS Detection:")
  print("Windows:", ON_WINDOWS_OS)
  print("NixOS:", ON_LINUX_NIXOS)
  print("Regular Linux:", ON_LINUX_NORMAL_OS)
end
if IN_GUI then
  print(
    "No GUI anymore. That phase is over. If you're using neovim, you are using it in the terminal. Otherwise use another GUI editor.")
  return
end
if ON_WINDOWS_OS then
  vim.opt.fixendofline = false
  vim.opt.endofline = false
  vim.opt.fileformats = "dos,unix,mac"
end

WebFileTypes = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'astro' }

local config_terminal = require('config_terminal')
local config_lsp = require('config_lsp')
local config_telescope = require('config_telescope')
local config_treesitter = require('config_treesitter')
local config_git = require('config_git')
local config_comment = require('config_comment')
local config_indentline = require('config_indentline')
local config_pair = require('config_pair')
local config_colors = require('config_colors')
local config_multicursors = require('config_multicursors')
local config_search_and_replace = require('config_search_and_replace')
local config_oil = require('config_oil')
local config_harpoon = require('config_harpoon')
local config_lualine = require('config_lualine')
require('config_build')

-- space as leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true -- Curr Pref: [Cousine Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Cousine.zip)

-- default tab options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 1000

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Default listchars off, have keymap to toggle it on/off if need to see
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.wrap = false

-- Toggle show whitespace chars
vim.keymap.set('n', '<leader>tws', function()
  vim.opt.listchars = { tab = '» ', space = '·', trail = '·', nbsp = '␣' }
  vim.wo.list = not vim.wo.list
end)

-- Allow moving text selected in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'H', 'xhhp`[v`]')
vim.keymap.set('v', 'L', 'xp`[v`]')

-- More convenient code fold hotkeys
vim.keymap.set('v', 'ff', 'zf');
vim.keymap.set('n', 'fa', 'za');
vim.keymap.set('v', 'fa', 'za');
vim.keymap.set('n', 'fb', 'zf%'); -- help to fold a block

-- Extra navigation shortcuts
vim.keymap.set('n', 'gh', '_')
vim.keymap.set('n', 'gl', 'g_')
vim.keymap.set('v', 'gh', '_')
vim.keymap.set('v', 'gl', 'g_')
vim.keymap.set('n', '<leader>w', ':w<CR>')
-- Select current hovered over word and start search
vim.keymap.set('n', 'gn', '/\\V\\<<C-R><C-W>\\><CR>', { desc = 'Search current word' })
-- Search currently selected text
vim.keymap.set('v', 'gn', 'y/\\V<C-R>"<CR>', { desc = 'Search selected text' })

-- terminal keymaps
vim.keymap.set('n', '<A-;>', config_terminal.toggle_floating_term)
vim.keymap.set('t', '<A-;>', config_terminal.toggle_floating_term)
vim.keymap.set('n', '<A-n>', function()
  if config_terminal.is_in_floating_term() then
    config_terminal.new_terminal()
    return
  end
  vim.cmd(':tabnew')
end)
vim.keymap.set('t', '<A-n>', config_terminal.new_terminal)
vim.keymap.set('n', '<A-w>', config_terminal.close_current_terminal)
vim.keymap.set('t', '<A-w>', config_terminal.close_current_terminal)
vim.keymap.set('n', '<A-k>', function() config_terminal.cycle_terminal(-1) end)
vim.keymap.set('t', '<A-k>', function() config_terminal.cycle_terminal(-1) end)
vim.keymap.set('n', '<A-j>', function() config_terminal.cycle_terminal(1) end)
vim.keymap.set('t', '<A-j>', function() config_terminal.cycle_terminal(1) end)

-- tab keymaps
vim.keymap.set('n', '<A-.>', ':tabnext<CR>')
vim.keymap.set('n', '<A-,>', ':tabprev<CR>')
vim.keymap.set('n', '<A-c>', ':tabclose<CR>')
vim.keymap.set('n', '<A-<>', ':-tabmove<CR>', { desc = 'Move tab left' })
vim.keymap.set('n', '<A->>', ':+tabmove<CR>', { desc = 'Move tab right' })
for i = 1, 9 do
  vim.keymap.set('n', '<A-' .. i .. '>', i .. 'gt', { desc = 'Go to tab ' .. i })
end

-- copy path of current buffer (file or directory) to system clipboard
vim.keymap.set('n', '<leader>cp', function()
  local path
  if vim.bo.filetype == 'oil' then
    path = require('oil').get_current_dir()
  else
    path = vim.fn.expand('%:p')
  end
  vim.fn.setreg('+', path)
end)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic quickfix [L]ist' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to Diagnostic quickfix Next' })
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to Diagnostic quickfix Previous' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

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

-- autocommand group for tab widths for differnet languages
vim.api.nvim_create_augroup('SetTabWidth', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = 'SetTabWidth',
  pattern = vim.list_extend(WebFileTypes, { 'lua', 'nix', 'yaml', 'toml' }),
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})

-- set auto-indentation options for c/c++
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.opt_local.cindent = true
    vim.opt_local.autoindent = false

    -- TODO: find the right options to get proper indentation levels for C style switch case statements
    vim.opt_local.cinoptions = ':0,l1'

    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  config_lsp,
  config_telescope,
  config_treesitter,
  config_git,
  config_comment,
  config_indentline,
  config_pair,
  config_colors,
  config_multicursors,
  config_search_and_replace,
  config_oil,
  config_harpoon,
  config_lualine,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et