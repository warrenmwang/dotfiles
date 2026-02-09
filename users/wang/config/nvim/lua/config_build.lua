local function is_not_special_window(win_id)
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local filetype = vim.bo[bufnr].filetype
  return not (filetype == 'oil')
end

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
    if win2_pos[2] > win1_pos[2] and win2_pos[1] == 0 and is_not_special_window(win2) then
      vim.api.nvim_set_current_win(win2)
    elseif win1_pos[2] > win2_pos[2] and win1_pos[1] == 0 and is_not_special_window(win1) then
      vim.api.nvim_set_current_win(win1)
      -- stacked splits (choose the leftmost bottom window)
    elseif win2_pos[1] > win1_pos[1] and win2_pos[2] == 0 and is_not_special_window(win2) then
      vim.api.nvim_set_current_win(win2)
    elseif win1_pos[1] > win2_pos[1] and win1_pos[2] == 0 and is_not_special_window(win1) then
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
      if curr_win_col > largest_col and curr_win_row == 0 and is_not_special_window(win_id) then
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
