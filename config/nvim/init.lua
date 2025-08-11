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

-- Globals
DEBUG = true
ON_WINDOWS_OS = vim.fn.has 'win32' == 1
ON_LINUX_NIXOS = vim.fn.has 'unix' == 1 and vim.fn.executable('nix') == 1
ON_LINUX_NORMAL_OS = vim.fn.has 'unix' == 1 and not ON_WINDOWS_OS and not ON_LINUX_NIXOS
WebFileTypes = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }

if DEBUG then
  print("OS Detection:")
  print("Windows:", ON_WINDOWS_OS)
  print("NixOS:", ON_LINUX_NIXOS)
  print("Regular Linux:", ON_LINUX_NORMAL_OS)
end

-- Shell configuration for windows
if ON_WINDOWS_OS then
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

if vim.fn.has 'gui_running' == 1 then
  vim.opt.guifont = 'Cousine Nerd Font Mono:h12'
  if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0 -- cursor smear; default: 0.15
    vim.g.neovide_scroll_animation_length = 0 -- smooth scroll; default: 0.3
    vim.g.neovide_position_animation_length = 0 -- default: 0.15
    vim.g.neovide_hide_mouse_when_typing = true

    -- dynamically resizable text
    -- orig: https://github.com/neovide/neovide/discussions/2301#discussioncomment-8223203
    vim.keymap.set({ 'n', 'v' }, '<C-=>', function()
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    end)
    vim.keymap.set({ 'n', 'v' }, '<C-->', function()
      if vim.g.neovide_scale_factor > 0.2 then
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
      end
    end)
    vim.keymap.set({ 'n', 'v' }, '<C-ScrollWheelUp>', function()
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    end)
    vim.keymap.set({ 'n', 'v' }, '<C-ScrollWheelDown>', function()
      if vim.g.neovide_scale_factor > 0.2 then
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
      end
    end)
    vim.keymap.set({ 'n', 'v' }, '<C-0>', function()
      vim.g.neovide_scale_factor = 1
    end)

    -- window mappings to enable expanding and shrinking window sizes with Ctrl+Shift + movement keys
    -- vim.keymap.set({ 'n', 'v' }, '<C-S-h>', '<cmd>vertical resize -5<CR>', { desc = 'Decrease window width' })
    -- vim.keymap.set({ 'n', 'v' }, '<C-S-l>', '<cmd>vertical resize +5<CR>', { desc = 'Increase window width' })
    -- vim.keymap.set({ 'n', 'v' }, '<C-S-k>', '<cmd>resize +5<CR>', { desc = 'Increase window height' })
    -- vim.keymap.set({ 'n', 'v' }, '<C-S-j>', '<cmd>resize -5<CR>', { desc = 'Decrease window height' })
  end
else
  -- IN TERMINAL MODE

  -- window mappings to enable expanding and shrinking window sizes with leader + movement keys
  -- vim.keymap.set({ 'n', 'v' }, '<leader>h', '<cmd>vertical resize -5<CR>', { desc = 'Decrease window width' })
  -- vim.keymap.set({ 'n', 'v' }, '<leader>l', '<cmd>vertical resize +5<CR>', { desc = 'Increase window width' })
  -- vim.keymap.set({ 'n', 'v' }, '<leader>k', '<cmd>resize +5<CR>', { desc = 'Increase window height' })
  -- vim.keymap.set({ 'n', 'v' }, '<leader>j', '<cmd>resize -5<CR>', { desc = 'Decrease window height' })
end

-- allow moving text selected in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'H', 'xhhp`[v`]')
vim.keymap.set('v', 'L', 'xp`[v`]')

-- default tab options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.number = true
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

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Disable line wrap
vim.opt.wrap = false

-- Minimal number of screen lines to keep above and below the cursor.
-- vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic quickfix [L]ist' })
vim.keymap.set('n', '<leader>dn', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to [D]iagnostic quickfix [N]ext' })
vim.keymap.set('n', '<leader>dp', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to [D]iagnostic quickfix [P]revious' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
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
  pattern = WebFileTypes,
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = 'SetTabWidth',
  pattern = { 'lua', 'nix' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = 'SetTabWidth',
  pattern = { 'yaml', 'toml' },
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

-- vim.keymap.set('n', '<A-h>', function()
--   print 'current window information:'
--   local win_id = vim.api.nvim_get_current_win()
--   local window = vim.api.nvim_win_get_config(win_id)

--   for k, v in pairs(window) do
--     print(k, vim.inspect(v))
--   end

--   local position = vim.api.nvim_win_get_position(win_id)
--   print('Row:', position[1], 'Col:', position[2])
-- end)

local function is_not_neo_tree_window(win_id)
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local filetype = vim.bo[bufnr].filetype
  return not (filetype == 'neo-tree')
end

-- Build Hotkey
local build_term_buf = nil
vim.keymap.set('n', '<A-m>', function()
  -- Find the build script in CWD
  local build_script
  local cwd = vim.fn.getcwd()
  local bat_path = cwd .. '/build.bat'
  local ps1_path = cwd .. '/build.ps1'
  local sh_path = cwd .. '/build.sh'

  if ON_WINDOWS_OS then
    if vim.fn.filereadable(bat_path) == 1 then
      build_script = bat_path
    elseif vim.fn.filereadable(ps1_path) == 1 then
      build_script = ps1_path
    end
  else
    if vim.fn.filereadable(sh_path) == 1 then
      build_script = sh_path
    end
  end

  if not build_script then
    vim.notify('No build script found', vim.log.levels.ERROR)
    return
  end

  local starting_window = vim.api.nvim_get_current_win()

  local window_ids = vim.api.nvim_list_wins()
  local num_windows = #window_ids

  -- Determine which window to run build command in
  if num_windows == 1 then
    vim.cmd 'vsplit'
  elseif num_windows == 2 then
    -- Attach to existing leftmost window (row must be 0 tho, if not create new split)
    -- if windows are actually stacked, then run in bottom one

    local win1 = window_ids[1]
    local win2 = window_ids[2]
    local win1_pos = vim.api.nvim_win_get_position(win1) -- [row,col]
    local win2_pos = vim.api.nvim_win_get_position(win2)

    -- vertical splits (choose the rightmost top window)
    if win2_pos[2] > win1_pos[2] and win2_pos[1] == 0 and is_not_neo_tree_window(win2) then
      vim.api.nvim_set_current_win(win2)
    elseif win1_pos[2] > win2_pos[2] and win1_pos[1] == 0 and is_not_neo_tree_window(win1) then
      vim.api.nvim_set_current_win(win1)
    -- stacked splits (choose the leftmost bottom window)
    elseif win2_pos[1] > win1_pos[1] and win2_pos[2] == 0 and is_not_neo_tree_window(win2) then
      vim.api.nvim_set_current_win(win2)
    elseif win1_pos[1] > win2_pos[1] and win1_pos[2] == 0 and is_not_neo_tree_window(win1) then
      vim.api.nvim_set_current_win(win1)
    else
      vim.cmd 'vsplit' -- other windows are special/should not be attached to, so create a new one
    end
  else
    -- At least 3 windows
    -- Attach to the rightmost window with row == 0 (workaround to avoid attaching to the rust analyzer buffer)
    local largest_col = 0
    local leftmost_window_id = nil

    for _, win_id in ipairs(window_ids) do
      local curr_win = vim.api.nvim_win_get_position(win_id)
      local curr_win_row = curr_win[1]
      local curr_win_col = curr_win[2]

      -- find the rightmost top window
      if curr_win_col > largest_col and curr_win_row == 0 and is_not_neo_tree_window(win_id) then
        largest_col = curr_win[2]
        leftmost_window_id = win_id
      end
    end

    if leftmost_window_id then
      vim.api.nvim_set_current_win(leftmost_window_id)
    else
      vim.cmd 'vsplit' -- other windows are special/should not be attached to, so create a new one
    end
  end

  -- Execute build script in selected window and buffer
  vim.cmd('terminal ' .. build_script)

  -- Close previous terminal buffer and save new one
  if build_term_buf and vim.api.nvim_buf_is_valid(build_term_buf) then
    vim.api.nvim_buf_delete(build_term_buf, { force = true })
    build_term_buf = nil
  end
  build_term_buf = vim.api.nvim_get_current_buf()

  -- Return to previous starting window
  vim.api.nvim_set_current_win(starting_window)
end, { desc = 'Run a build script in the CWD' })

-- Floating terminal config
local floating_term_state = {
  win = nil,
  buf = nil,
}
local function toggle_floating_term()
  if floating_term_state.win and vim.api.nvim_win_is_valid(floating_term_state.win) then
    -- close window if opened
    vim.api.nvim_win_close(floating_term_state.win, false)
    floating_term_state.win = nil
  else
    -- init buffer with terminal if not exist
    if not floating_term_state.buf or not vim.api.nvim_buf_is_valid(floating_term_state.buf) then
      floating_term_state.buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_call(floating_term_state.buf, function()
        vim.cmd 'terminal'
      end)
    end

    -- open/create window if closed
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)
    local opts = {
      relative = 'editor',
      width = width,
      height = height,
      col = col,
      row = row,
      anchor = 'NW',
      style = 'minimal',
      border = 'rounded',
      title = 'Terminal',
      title_pos = 'center',
    }
    floating_term_state.win = vim.api.nvim_open_win(floating_term_state.buf, true, opts)
    vim.cmd 'startinsert'
  end
end
vim.keymap.set('n', '<A-;>', toggle_floating_term)
vim.keymap.set('t', '<A-;>', toggle_floating_term)

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})


-- TODO: check if on NixOS, then we'll need to do some funky stuff
-- if vim.fn.has

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

require('lazy').setup {
  -- core plugins
  require 'core.plugins.lsp',
  require 'core.plugins.telescope',
  require 'core.plugins.treesitter',
  require 'core.plugins.git',
  require 'core.plugins.comment',

  -- kickstart plugins
  require 'kickstart.plugins.indent-line',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.lint',

  -- custom/misc plugins
  require 'custom.plugins.colors',
  require 'custom.plugins.vim-visual-multi',
  require 'custom.plugins.spectre',
  require 'custom.plugins.oil',
  require 'custom.plugins.barbar',
  require 'custom.plugins.harpoon',
  require 'custom.plugins.lualine',

  -- require 'custom.plugins.avante',
  -- TODO: can checkout supermaven if want that ai code completion, altho not really fan of, but could give another try.

  -- Web development
  require 'custom.plugins.autotags',
  require 'custom.plugins.typescript-tools',
  require 'custom.plugins.tailwind-tools',
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
