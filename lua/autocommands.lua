local util = require "util"

local M = {}

local last_file_type = ""
local file_open_buffer = {}

function M.add(to_add) vim.api.nvim_create_autocmd(to_add[1], to_add[2]) end

function M.add_mult(to_add)
  for _, v in ipairs(to_add) do
    M.add(v)
  end
end

function M.apply_to_files(filetype, action, func)
  if not file_open_buffer[filetype] then file_open_buffer[filetype] = {
    close = {},
    open = {},
  } end

  if type(filetype) ~= "table" then filetype = { filetype } end

  for _, ft in pairs(filetype) do
    table.insert(file_open_buffer[ft][action], func)
  end
end

function M.on_close_files(filetype, func) M.apply_to_files(filetype, "close", func) end

function M.on_open_files(filetype, func) M.apply_to_files(filetype, "open", func) end

function M.on_files(filetype, open_func, close_func)
  M.apply_to_files(filetype, "open", open_func)
  M.apply_to_files(filetype, "close", close_func)
end

M.exclude_ft = {
  "qf",
  "NvimTree",
  "toggleterm",
  "TelescopePrompt",
  "alpha",
  "netrw",
  "fugitive",
}

function M.is_in_sys_buffer() return vim.tbl_contains(M.exclude_ft, vim.o.filetype) end

-- TODO: swap to BufLeave check for the on close stuff (and only keep this for system buffer types)
M.add {
  { "Filetype", "BufEnter" },
  {
    desc = "Runs everything that has been asked of it",
    pattern = "*",
    callback = function()
      local ft = vim.o.filetype
      if ft == last_file_type then return end

      local function run_funcs_for(type, action)
        if file_open_buffer[type] then
          local funcs = file_open_buffer[type][action]
          if funcs then
            for v in util.list_iter(funcs) do
              v()
            end
          end
        end
      end

      if M.is_in_sys_buffer() then
        run_funcs_for("*", "close")
      elseif vim.o.buftype == "" then
        run_funcs_for("*", "open")
      end

      if ft == "*" then return end

      run_funcs_for(ft, "open")
      run_funcs_for(last_file_type, "close")

      last_file_type = ft
    end,
  },
}

return M
