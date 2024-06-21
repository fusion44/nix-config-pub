-- Define a function to cycle through windows
local function cycle_windows()
  local windows = vim.api.nvim_list_wins()
  local current_win = vim.api.nvim_get_current_win()
  local next_win_id

  local function is_floating_win(win_id)
    local win_config = vim.api.nvim_win_get_config(win_id)
    return win_config.relative ~= '' or win_config.external
  end

  -- Find the index of the current window in the list of windows
  for i, win in ipairs(windows) do
    if win == current_win then
      -- Calculate the next window ID, looping back to the first if necessary
      next_win_id = windows[((i % #windows) + 1)]
      break
    end
  end

  -- Check if the next window is a floating window or has a skipped buffer type
  while is_floating_win(next_win_id) or vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(next_win_id), 'filetype') == 'noice' do
    -- If the next window is a floating window or has a skipped buffer type, find the next window
    for i, win in ipairs(windows) do
      if win == next_win_id then
        next_win_id = windows[((i % #windows) + 1)]
        break
      end
    end
  end

  -- Move to the next window
  vim.api.nvim_set_current_win(next_win_id)
end
