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
local DEBUG = true
local ON_WINDOWS_OS = vim.fn.has 'win32' == 1
local ON_LINUX_NIXOS = vim.fn.has 'unix' == 1 and vim.fn.executable('nix') == 1
local ON_LINUX_NORMAL_OS = vim.fn.has 'unix' == 1 and not ON_WINDOWS_OS and not ON_LINUX_NIXOS
local WebFileTypes = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }

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

local config_lsp = {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        -- clangd = {},
        -- rust_analyzer = {},
        -- java_language_server = {},
        -- gopls = {},
        -- debugpy = {},
        -- pyright = {},
        -- tailwindcss = {}, -- (AKA tailwindcss-language-server)
        -- cssls = {},
        -- astro = {},
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- Put formatters and linters managed by Mason here
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        -- 'eslint',
        -- 'prettier',
        -- 'prettierd',
        -- 'sql-formatter',
        -- 'clang-format',
        -- 'ruff',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = false,
      -- format_on_save = function(bufnr)
      --   -- Disable "format_on_save lsp_fallback" for languages that don't
      --   -- have a well standardized coding style. You can add additional
      --   -- languages here or re-enable it for the disabled ones.
      --   local disable_filetypes = { c = true, cpp = true, javascript = true }
      --   return {
      --     timeout_ms = 500,
      --     lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      --   }
      -- end,
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },

        c = { 'clang_formatter' },
        cpp = { 'clang_formatter' },
        rust = { 'rustfmt' },

        python = { 'ruff' },

        html = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },

        sql = { 'sql_formatter' },
      },
      formatters = {
        sql_formatter = {
          command = 'sql-formatter',
          args = {
            '--config',
            (function()
              -- Use the CWD's sql-formatter.json format file if present
              local local_config = vim.fn.expand './.sql-formatter.json'
              if vim.fn.filereadable(local_config) == 1 then
                return local_config
              else
                -- Fallback to a global one
                if ON_WINDOWS_OS then
                  return vim.fn.getenv 'APPDATA' .. '\\..\\Local\\nvim\\.sql-formatter.json'
                else
                  return vim.fn.expand '~/.config/nvim/.sql-formatter.json'
                end
              end
            end)(),
          },
        },
        clang_formatter = {
          command = 'clang-format',
          args = {
            '-style=file:' .. (function()
              -- Use the CWD's clang format file if present
              local local_config = vim.fn.expand './.clang-format'
              if vim.fn.filereadable(local_config) == 1 then
                return local_config
              else
                -- Fallback to a global one
                if ON_WINDOWS_OS then
                  return vim.fn.getenv 'APPDATA' .. '\\..\\Local\\nvim\\.clang-format'
                else
                  return vim.fn.expand '~/.config/nvim/.clang-format'
                end
              end
            end)(),
          },
        },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if ON_WINDOWS_OS or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          ['<Tab>'] = cmp.mapping.confirm { select = true },
          --['<CR>'] = cmp.mapping.confirm { select = true },
          -- ['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
  { -- replaces typescript-language-server
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    lazy = true,
    ft = WebFileTypes,
  }
}

local config_commentary = {
  'tpope/vim-commentary',
  keys = {
    { 'gc', ':Commentary' },
    { mode = 'v', 'gc', ':Commentary' },
  },
}

local config_git = {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>gg', '<cmd>Git<CR>', { desc = 'Open Git Fugitive' } },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        -- map('v', '<leader>hs', function()
        --   gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        -- end, { desc = 'stage git hunk' })
        -- map('v', '<leader>hr', function()
        --   gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        -- end, { desc = 'reset git hunk' })

        -- normal mode
        -- map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        -- map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        -- map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        -- map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        -- map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>gp', gitsigns.preview_hunk_inline, { desc = 'git [p]review hunk inline' })
        map('n', '<leader>gb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        -- map('n', '<leader>gD', function()
        --   gitsigns.diffthis '@'
        -- end, { desc = 'git [D]iff against last commit' })
        --
        -- Toggles
        map('n', '<leader>glb', gitsigns.toggle_current_line_blame, { desc = 'git [T]oggle show [b]lame line' })
        -- map('n', '<leader>gtD', gitsigns.toggle_deleted, { desc = '[G]it [T]oggle show [D]eleted' })
      end,
    },
  },
}

local config_telescope = { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   -- mappings = {
      --   --   i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   -- },
      --
      -- },
      -- pickers = {
      --   find_files = {
      --     find_command = { 'rg', '--files', '--hidden', '--no-ignore' },
      --   },
      -- },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set(
      'n',
      '<leader>si',
      [[<cmd>lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '--no-ignore' } })<CR>]],
      { noremap = true, silent = true, desc = '[S]earch Git [I]gnored files' }
    )

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}

local config_treesitter = { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    -- ensure_installed = {
    --   'lua',
    --   'luadoc',
    -- },
    -- ensure_installed = {
    --   'c',
    --   'bash',
    --   'diff',
    --   'html',
    --   'css',
    --   'lua',
    --   'luadoc',
    --   'astro',
    --   'markdown',
    --   'markdown_inline',
    --   'query',
    --   'vim',
    --   'vimdoc',
    --   'python',
    --   'go',
    --   'java',
    --   'javascript',
    --   'typescript',
    --   'tsx',
    -- },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  config = function(_, opts)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

    -- Associate specific parsers to specific filetypes, if needed
    -- this one associates tsx parser to the typescriptreact filetype
    vim.treesitter.language.register('tsx', 'typescriptreact')

    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}

local config_indent_line = {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      scope = { enabled = true }, -- set to true to enable highlighting of the current scope (requires tree-sitter)
    },
  },
}

local config_autopairs = {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  -- Optional dependency
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    require('nvim-autopairs').setup {
      disable_filetype = { 'TelescopePrompt', 'vim' },
    }
    -- If you want to automatically add `(` after selecting a function or method
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}

local config_neo_tree = {
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

local config_colors = {
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

local config_vim_multi_cursor = {
  'mg979/vim-visual-multi',
}

local config_spectre = {
  'nvim-pack/nvim-spectre',
  config = function()
    require('spectre').setup()
  end,
  lazy = true,
  keys = {
    { '<leader>sr', '<cmd>Spectre<CR>', { desc = '[S]earch and [R]eplace across Files', noremap = true, silent = true } },
  },
}

local config_oil = {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    view_options = {
      show_hidden = true,
    },
    skip_confirm_for_simple_edits = true,
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
  keys = {
    { '<leader>o', '<cmd>Oil<CR>' },
  },
}

local config_barbar = {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = true

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- Move to previous/next
    map('n', '<A-p>', '<Cmd>BufferPrevious<CR>', opts)
    map('n', '<A-n>', '<Cmd>BufferNext<CR>', opts)
    -- Re-order to previous/next
    map('n', '<A-S-p>', '<Cmd>BufferMovePrevious<CR>', opts)
    map('n', '<A-S-n>', '<Cmd>BufferMoveNext<CR>', opts)
    -- Goto buffer in position...
    map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
    map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
    map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
    map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
    map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
    map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
    map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
    map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
    map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
    map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)

    -- Pin/unpin buffer
    -- map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
    -- Goto pinned/unpinned buffer
    --                 :BufferGotoPinned
    --                 :BufferGotoUnpinned
    -- Close buffer
    map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
    map('n', '<A-C>', '<Cmd>BufferClose!<CR>', opts)
    -- Wipeout buffer
    --                 :BufferWipeout
    -- Close commands
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight
    -- Magic buffer-picking mode
    -- map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
    -- Sort automatically by...
    -- map('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    -- map('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>', opts)
    -- map('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    -- map('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    -- map('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
    -- map('n', '<leader>bc', '<Cmd>BufferCloseAllButCurrent<Cr>', opts)
  end,
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
}

local config_harpoon = {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = 'Harpoon: Add current file to menu' })

    vim.keymap.set('n', '<leader>hl', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Toggle Quick Menu' })

    vim.keymap.set('n', '<leader>h1', function()
      harpoon:list():select(1)
    end, { desc = 'Harpoon: Jump to item 1' })

    vim.keymap.set('n', '<leader>h2', function()
      harpoon:list():select(2)
    end, { desc = 'Harpoon: Jump to item 2' })

    vim.keymap.set('n', '<leader>h3', function()
      harpoon:list():select(3)
    end, { desc = 'Harpoon: Jump to item 3' })

    vim.keymap.set('n', '<leader>h4', function()
      harpoon:list():select(4)
    end, { desc = 'Harpoon: Jump to item 4' })

    vim.keymap.set('n', '<leader>h5', function()
      harpoon:list():select(5)
    end, { desc = 'Harpoon: Jump to item 5' })

    vim.keymap.set('n', '<leader>h6', function()
      harpoon:list():select(6)
    end, { desc = 'Harpoon: Jump to item 6' })

    vim.keymap.set('n', '<leader>h7', function()
      harpoon:list():select(7)
    end, { desc = 'Harpoon: Jump to item 7' })

    vim.keymap.set('n', '<leader>h8', function()
      harpoon:list():select(8)
    end, { desc = 'Harpoon: Jump to item 8' })

    vim.keymap.set('n', '<leader>h9', function()
      harpoon:list():select(9)
    end, { desc = 'Harpoon: Jump to item 9' })

    vim.keymap.set('n', '<leader>h0', function()
      harpoon:list():select(10)
    end, { desc = 'Harpoon: Jump to item 10' })
  end,
}

local config_lualine = {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  config = function()
    local lualine = require 'lualine'

    local function get_file_size()
      local filename = vim.fn.expand '%:p'
      local file_exists = vim.fn.filereadable(filename) == 1

      if file_exists then
        local bytes = vim.fn.getfsize(filename)
        if bytes == -1 then
          return ''
        end

        local sizes = { 'B', 'KB', 'MB', 'GB' }
        local i = 1
        while bytes >= 1024 and i < #sizes do
          bytes = bytes / 1024
          i = i + 1
        end
        return string.format('%.2f %s', bytes, sizes[i])
      end
      return ''
    end

    lualine.setup {
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { get_file_size },
        lualine_z = { 'progress', 'location' },
      },
    }
  end,
}

local config_autotags = {
  -- auto close and auto rename html tags
  'windwp/nvim-ts-autotag',
  config = function()
    require('nvim-ts-autotag').setup {
      filetypes = {
        'html',
        'xml',
        'markdown',
        'javascriptreact',
        'typescriptreact',
      },
    }
  end,
  dependencies = 'nvim-treesitter/nvim-treesitter',
  lazy = true,
  ft = WebFileTypes,
}

-- NOTE: requires tailwindcss-language-server
local config_tailwind_tools = {
  'luckasRanarison/tailwind-tools.nvim',
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    'neovim/nvim-lspconfig',
  },
  opts = {},
  lazy = true,
  ft = WebFileTypes,
}

local config_lint = {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}

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
  require config_lsp,
  require config_telescope,
  require config_treesitter,
  require config_git,
  require config_commentary,

  -- kickstart plugins
  require config_indent_line,
  require config_autopairs,
  require config_neo_tree,
  -- require config_lint,

  -- custom/misc plugins
  require config_colors,
  require config_vim_multi_cursor,
  require config_spectre,
  require config_oil,
  -- require config_barbar,
  require config_harpoon,
  require config_lualine,

  -- Web development
  require config_autotags,
  -- require config_tailwind_tools
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
