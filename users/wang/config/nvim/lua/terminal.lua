local M = {}

local floating_term_state = {
  win = nil,
  buffers = {},
  current_index = 1,
}
M.floating_term_state = floating_term_state

function M.is_in_floating_term()
  return M.floating_term_state.win and vim.api.nvim_win_is_valid(M.floating_term_state.win)
end

function M.create_terminal_title()
  if #floating_term_state.buffers == 0
  then
    return "Terminal"
  end

  local title = string.format("Terminal %d/%d",
                              floating_term_state.current_index,
                              #floating_term_state.buffers)
  return title
end

-- create new term buffer, add it to the buffers table state, and update curr index to it
function M.create_new_terminal()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_call(buf, function() vim.cmd 'terminal' end)

  table.insert(floating_term_state.buffers, buf)
  floating_term_state.current_index = #floating_term_state.buffers

  return buf
end

function M.close_current_terminal()
  local is_term_win_open = floating_term_state.win and vim.api.nvim_win_is_valid(floating_term_state.win)
  if not is_term_win_open then return end

  if #floating_term_state.buffers == 0
  then
    return
  end
 
  local buf_to_delete = floating_term_state.buffers[floating_term_state.current_index]
  local index_of_buf_to_delete = floating_term_state.current_index

  -- last term: create a new one to replace it
  if floating_term_state.win
     and vim.api.nvim_win_is_valid(floating_term_state.win)
     and #floating_term_state.buffers == 1
  then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(buf, function() vim.cmd 'terminal' end)
    table.insert(floating_term_state.buffers, buf)

    vim.api.nvim_win_set_buf(floating_term_state.win, buf)

    table.remove(floating_term_state.buffers, index_of_buf_to_delete)
    if vim.api.nvim_buf_is_valid(buf_to_delete) then
      vim.api.nvim_buf_delete(buf_to_delete, { force = true })
    end

    floating_term_state.current_index = 1
    local title = M.create_terminal_title()
    vim.api.nvim_win_set_config(floating_term_state.win, { title = title })
  end

  -- at least one other term: switch to prev/next term
  if floating_term_state.win
     and vim.api.nvim_win_is_valid(floating_term_state.win)
     and #floating_term_state.buffers > 1
  then
    local new_curr_index

    if floating_term_state.current_index == 1
    then
      new_curr_index = floating_term_state.current_index + 1
    else
      new_curr_index = floating_term_state.current_index - 1
    end

    local buf = floating_term_state.buffers[new_curr_index]
    vim.api.nvim_win_set_buf(floating_term_state.win, buf)

    table.remove(floating_term_state.buffers, index_of_buf_to_delete)
    if vim.api.nvim_buf_is_valid(buf_to_delete) then
      vim.api.nvim_buf_delete(buf_to_delete, { force = true })
    end

    floating_term_state.current_index = new_curr_index
    local title = M.create_terminal_title()
    vim.api.nvim_win_set_config(floating_term_state.win, { title = title })
  end 
end

function M.cycle_terminal(direction)
  local is_term_win_open = floating_term_state.win and vim.api.nvim_win_is_valid(floating_term_state.win)
  if not is_term_win_open then return end

  if #floating_term_state.buffers <= 1 then
    return
  end

  if direction > 0 then -- Next (A-j)
    floating_term_state.current_index = floating_term_state.current_index + 1
    if floating_term_state.current_index > #floating_term_state.buffers then
      floating_term_state.current_index = 1
    end
  else -- Previous (A-k)
    floating_term_state.current_index = floating_term_state.current_index - 1
    if floating_term_state.current_index < 1 then
      floating_term_state.current_index = #floating_term_state.buffers
    end
  end

  if floating_term_state.win and vim.api.nvim_win_is_valid(floating_term_state.win) then
    local current_buf = floating_term_state.buffers[floating_term_state.current_index]
    vim.api.nvim_win_set_buf(floating_term_state.win, current_buf)

    local title = M.create_terminal_title()
    vim.api.nvim_win_set_config(floating_term_state.win, { title = title })

    vim.cmd 'startinsert'
  end
end

function M.new_terminal()
  M.create_new_terminal()

  if floating_term_state.win and vim.api.nvim_win_is_valid(floating_term_state.win) then
    local current_buf = floating_term_state.buffers[floating_term_state.current_index]
    vim.api.nvim_win_set_buf(floating_term_state.win, current_buf)

    local title = M.create_terminal_title()
    vim.api.nvim_win_set_config(floating_term_state.win, { title = title })

    vim.cmd 'startinsert'
  end
end

function M.toggle_floating_term()
  local is_term_win_open = floating_term_state.win and vim.api.nvim_win_is_valid(floating_term_state.win)

  if is_term_win_open then
    vim.api.nvim_win_close(floating_term_state.win, false)
    floating_term_state.win = nil
    return
  end

  if not is_term_win_open then
    -- Clean up any invalid buffers
    for i = #floating_term_state.buffers, 1, -1 do
      if not vim.api.nvim_buf_is_valid(floating_term_state.buffers[i]) then
        table.remove(floating_term_state.buffers, i)
        if floating_term_state.current_index > i then
          floating_term_state.current_index = floating_term_state.current_index - 1
        end
      end
    end

    -- Adjust current_index if needed
    if floating_term_state.current_index > #floating_term_state.buffers then
      floating_term_state.current_index = math.max(1, #floating_term_state.buffers)
    end

    -- Create new terminal if none exist after clean / on startup
    if #floating_term_state.buffers == 0 then
      M.create_new_terminal()
    end

    -- Open window with current buffer
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local title = M.create_terminal_title()
    local opts = {
      relative = 'editor',
      width = width,
      height = height,
      col = col,
      row = row,
      anchor = 'NW',
      style = 'minimal',
      border = 'rounded',
      title = title,
      title_pos = 'center',
    }

    local current_buf = floating_term_state.buffers[floating_term_state.current_index]
    floating_term_state.win = vim.api.nvim_open_win(current_buf, true, opts)
    vim.cmd 'startinsert'
  end
end

return M
