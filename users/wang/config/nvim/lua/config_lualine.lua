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

return config_lualine
