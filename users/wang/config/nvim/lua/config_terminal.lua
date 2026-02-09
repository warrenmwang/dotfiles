local M = {}

M.floating_term_state = {
  win = nil,
  buffers = {},
  current_index = 1,
}

function M.is_in_floating_term()
  return M.floating_term_state.win and vim.api.nvim_win_is_valid(M.floating_term_state.win)
end

function M.create_terminal_title()
  if #M.floating_term_state.buffers == 0 then return "Terminal" end
  return string.format("Terminal %d/%d",
                        M.floating_term_state.current_index,
                        #M.floating_term_state.buffers)
end

-- create new term buffer, add it to the buffers table state, and update curr index to it
function M.create_new_terminal()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_call(buf, function() vim.cmd 'terminal' end)

  table.insert(M.floating_term_state.buffers, buf)
  M.floating_term_state.current_index = #M.floating_term_state.buffers

  return buf
end

function M.close_current_terminal()
  local is_term_win_open = M.floating_term_state.win and vim.api.nvim_win_is_valid(M.floating_term_state.win)
  if not is_term_win_open then return end
  if #M.floating_term_state.buffers == 0 then return end

  local buf_to_delete = M.floating_term_state.buffers[M.floating_term_state.current_index]
  local index_of_buf_to_delete = M.floating_term_state.current_index

  -- last term: create a new one to replace it
  if M.floating_term_state.win
     and vim.api.nvim_win_is_valid(M.floating_term_state.win)
     and #M.floating_term_state.buffers == 1
  then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(buf, function() vim.cmd 'terminal' end)
    table.insert(M.floating_term_state.buffers, buf)

    vim.api.nvim_win_set_buf(M.floating_term_state.win, buf)

    table.remove(M.floating_term_state.buffers, index_of_buf_to_delete)

    if vim.api.nvim_buf_is_valid(buf_to_delete)
    then
      vim.api.nvim_buf_delete(buf_to_delete, { force = true })
    end

    M.floating_term_state.current_index = 1
    local title = M.create_terminal_title()
    vim.api.nvim_win_set_config(M.floating_term_state.win, { title = title })
  end

  -- at least one other term: switch to prev/next term
  if M.floating_term_state.win
     and vim.api.nvim_win_is_valid(M.floating_term_state.win)
     and #M.floating_term_state.buffers > 1
  then
    local new_curr_index = M.floating_term_state.current_index + 1

    local was_at_end = false
    if new_curr_index > #M.floating_term_state.buffers
    then
      new_curr_index = #M.floating_term_state.buffers - 1
      was_at_end = true
    end

    local new_curr_buf = M.floating_term_state.buffers[new_curr_index]
    vim.api.nvim_win_set_buf(M.floating_term_state.win, new_curr_buf)

    table.remove(M.floating_term_state.buffers, index_of_buf_to_delete)
    if buf_to_delete ~= nil and vim.api.nvim_buf_is_valid(buf_to_delete)
    then
      vim.api.nvim_buf_delete(buf_to_delete, { force = true })
    end

    if not was_at_end
    then
      new_curr_index = new_curr_index - 1
    end

    M.floating_term_state.current_index = new_curr_index
    local title = M.create_terminal_title()
    vim.api.nvim_win_set_config(M.floating_term_state.win, { title = title })
  end
end

function M.cycle_terminal(direction)
  local is_term_win_open = M.floating_term_state.win and vim.api.nvim_win_is_valid(M.floating_term_state.win)
  if not is_term_win_open then return end
  if #M.floating_term_state.buffers <= 1 then return end

  if direction > 0 then -- Next (A-j)
    M.floating_term_state.current_index = M.floating_term_state.current_index + 1
    if M.floating_term_state.current_index > #M.floating_term_state.buffers
    then
      M.floating_term_state.current_index = 1
    end
  else -- Previous (A-k)
    M.floating_term_state.current_index = M.floating_term_state.current_index - 1
    if M.floating_term_state.current_index < 1
    then
      M.floating_term_state.current_index = #M.floating_term_state.buffers
    end
  end

  if M.floating_term_state.win and vim.api.nvim_win_is_valid(M.floating_term_state.win)
  then
    local current_buf = M.floating_term_state.buffers[M.floating_term_state.current_index]
    vim.api.nvim_win_set_buf(M.floating_term_state.win, current_buf)

    local title = M.create_terminal_title()
    vim.api.nvim_win_set_config(M.floating_term_state.win, { title = title })

    vim.cmd 'startinsert'
  end
end

function M.new_terminal()
  M.create_new_terminal()

  if M.floating_term_state.win and vim.api.nvim_win_is_valid(M.floating_term_state.win)
  then
    local current_buf = M.floating_term_state.buffers[M.floating_term_state.current_index]
    vim.api.nvim_win_set_buf(M.floating_term_state.win, current_buf)

    local title = M.create_terminal_title()
    vim.api.nvim_win_set_config(M.floating_term_state.win, { title = title })

    vim.cmd 'startinsert'
  end
end

function M.toggle_floating_term()
  local is_term_win_open = M.floating_term_state.win and vim.api.nvim_win_is_valid(M.floating_term_state.win)

  if is_term_win_open
  then
    vim.api.nvim_win_close(M.floating_term_state.win, false)
    M.floating_term_state.win = nil
    return
  end

  if not is_term_win_open
  then
    -- Clean up any invalid buffers
    for i = #M.floating_term_state.buffers, 1, -1 do
      if not vim.api.nvim_buf_is_valid(M.floating_term_state.buffers[i])
      then
        table.remove(M.floating_term_state.buffers, i)
        if M.floating_term_state.current_index > i
        then
          M.floating_term_state.current_index = M.floating_term_state.current_index - 1
        end
      end
    end

    -- Adjust current_index if needed
    if M.floating_term_state.current_index > #M.floating_term_state.buffers
    then
      M.floating_term_state.current_index = math.max(1, #M.floating_term_state.buffers)
    end

    -- Create new terminal if none exist after clean / on startup
    if #M.floating_term_state.buffers == 0
    then
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

    local current_buf = M.floating_term_state.buffers[M.floating_term_state.current_index]
    M.floating_term_state.win = vim.api.nvim_open_win(current_buf, true, opts)
    vim.cmd 'startinsert'
  end
end

return M
