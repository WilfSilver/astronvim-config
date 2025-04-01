local M = {}

---@param text string
---@param prefix string
function M.starts_with(text, prefix) return text:find(prefix, 1, true) == 1 end

---@param t string|table
function M.get_iter_for(t)
  if type(t) == "table" then
    return M.list_iter(t)
  else
    return t:gmatch "."
  end
end

-- Returns the position of the cursor relative to the terminal
-- There's got to be a better method
function M.get_relative_cursor_pos()
  local win_pos = vim.api.nvim_win_get_position(0)
  local curr_pos = vim.api.nvim_win_get_cursor(0)
  local bufferline_height = 1

  local row = win_pos[1] + curr_pos[1] + bufferline_height

  local nw = vim.o.numberwidth
  local curr_col = curr_pos[2]
  if vim.opt.wrap then
    local win_width = vim.api.nvim_win_get_width(0) - nw - 2
    curr_col = curr_pos[2] % win_width
  end

  -- +3 to make sure first column starts at 0
  local col = win_pos[2] + curr_col + nw + 2

  return { row, col }
end

function M.list_iter(t)
  local i = 0
  local n = #t
  return function()
    i = i + 1
    if i <= n then return t[i] end
  end
end

function M.list_merge_into(into, from)
  for v in M.list_iter(from) do
    table.insert(into, v)
  end
end

function M.find(tbl, fn)
  for v in M.list_iter(tbl) do
    if fn(v) then return v end
  end
  return nil
end

function M.tbl_dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then k = '"' .. k .. '"' end
      s = s .. "[" .. k .. "] = " .. M.tbl_dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

-- Taken from http://stackoverflow.com/questions/640642/ddg#641993
--- @param t table
--- @return table
function M.tbl_shallow_copy(t)
  local t2 = {}
  for k, v in pairs(t) do
    t2[k] = v
  end
  return t2
end

return M
