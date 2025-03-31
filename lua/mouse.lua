local util = require "util"

-- TODO: Add specific menu for nvimtree
--
-- TODO: Add spelling menu
-- TODO: Add goto definition
-- TODO: Add peak definition
-- TODO: Add gitsigns stage/unstage
-- TODO: Add format document with
-- TODO: Add debug menu
local M = {}

-- TODO: Add ability for options like icon
local ft_to_opts = {
  i = {
    default = {
      { "Goto definition", "gd" },
      { "Peak definition", "gpd" },
      {},
      { "Paste", '<esc>"+Pi' },
      { "Select All", "<esc>ggVG" },
      {}, -- TODO: call these directly (and move to other files)
      { "Stage Hunk", "<esc><leader>gs" },
      { "Unstage Hunk", "<esc><leader>gu" },
      {},
      { "Start debug", "<esc><leader>ds" },
      { "Run to cursor", "<esc><leader>dC" },
      { "Continue", "<esc><leader>dc" },
      { "Step Back", "<esc><leader>db" },
      { "Step Into", "<esc><leader>di" },
      { "Step Over", "<esc><leader>do" },
      { "Run to cursor", "<esc><leader>dC" },
      { "Pause debug", "<esc><leader>dp" },
      { "Toggle breakpoint", "<esc><leader>dt" },
      {},
      {
        "Format document",
        function() vim.lsp.buf.format { async = true } end,
      },
    },
  },
  n = {
    NvimTree = {
      { "Open", "o" },
      { "Open Tab", "<C-t>" },
      { "Open Vertial", "<C-v>" },
      { "Open Horizontal", "<C-x>" },
      { "Copy Relative Path", "Y" },
      { "Info", "<C-z>" },
      {}, -- TODO: Add git staging?
      { "New File/Folder", "a" },
      { "Rename", "r" },
      { "Delete", "d" },
      { "Mark", "m" },
      { "Move to\\.\\.\\.", "mbmv" },
      {},
      { "Cut", "x" },
      { "Copy", "y" },
      { "Paste", "p" },
    },
    default = {
      { "Goto definition", "gd" },
      { "Peak definition", "gpd" },
      {},
      { "Paste", '"+P' },
      { "Select All", "ggVG" },
      {}, -- TODO: call these directly (and move to other files) (only appear in git also)
      { "Stage Hunk", "<leader>gs" },
      { "Unstage Hunk", "<leader>gu" },
      {},
      { "Start debug", "<leader>ds" },
      { "Run to cursor", "<leader>dC" },
      { "Toggle breakpoint", "<leader>dt" },
      { "Continue", "<leader>dc" },
      { "Step Back", "<leader>db" },
      { "Step Into", "<leader>di" },
      { "Step Over", "<leader>do" },
      { "Pause debug", "<leader>dp" },
      {},
      {
        "Format document",
        function() vim.lsp.buf.format { async = true } end,
      },
    },
  },
  v = {
    default = {
      { "Goto definition", "<esc>gd" },
      { "Peak definition", "<esc>gpd" },
      {},
      { "Cut", '"+x' },
      { "Copy", '"+y' },
      { "Paste", '"+P' },
      { "Delete", '"_x' },
      { "Select All", "<esc>ggVG" },
      {}, -- TODO: Make is so these actually work
      { "Find Word", "<leader>fw" },
      { "Search Current File", "<leader>fp" },
      {},
      {
        "Format document",
        function() vim.lsp.buf.format { async = true } end,
      },
    },
  },
}

local current = ""

function M.is_filetype_default(ft)
  for _, m_opts in pairs(ft_to_opts) do
    if m_opts[ft] ~= nil then return false end
  end
  return true
end

function M.set_options(filetype, modes, options)
  for m in util.get_iter_for(modes) do
    ft_to_opts[m][filetype] = options
  end
end

-- TODO: Add configuration
-- TODO: allow user to set position/priority
function M.add_option(filetype, modes, name, command)
  for m in util.get_iter_for(modes) do
    if ft_to_opts[m][filetype] == nil then ft_to_opts[m][filetype] = {} end

    ft_to_opts[m][filetype][name] = command
  end
end

-- Yes, just don't ask
function M.lua_routing(mode, ft, index) ft_to_opts[mode][ft][index][2]() end

function M.set_popup_menu(ft)
  if M.is_filetype_default(ft) then ft = "default" end

  if ft ~= current then
    current = ft
    vim.cmd "aunmenu PopUp"
    local submenus = {} -- submenus don't seem to work with the mouse...
    local blank_lines = 1
    for m, m_opts in pairs(ft_to_opts) do
      local opts = m_opts[ft]
      if opts == nil then opts = m_opts["default"] end

      local cmd = m .. "menu PopUp."
      for i, row in ipairs(opts) do
        if #row == 0 then
          row = { "-" .. blank_lines .. "-", "<Nop>" }
          blank_lines = blank_lines + 1
        elseif #row == 1 then
          table.insert(row, "<Nop>")
          if row[1]:len() == 0 or row[1]:sub(-1) == "." then row[1] = row[1] .. "-1-" end
        end

        local name = row[1]:gsub(" ", "\\ ")

        -- Creates a sub menu if it doesn't exist
        local sub = vim.gsplit(name, ".[^.]*$")()
        if sub ~= "" and not vim.tbl_contains(submenus, sub) then
          -- vim.cmd('menu PopUp.' .. sub)
          -- vim.cmd(cmd .. sub .. ' <cmd>popup PopUp.' .. sub .. '<cr>')
          table.insert(submenus, sub)
        end

        local value
        if type(row[2]) == "function" then
          -- TODO: Research a better way of doing this
          value = "<cmd>lua require('mouse').lua_routing('" .. m .. "', '" .. ft .. "', " .. i .. ")<cr>"
        else
          value = row[2]
        end
        local full_cmd = cmd .. name .. " " .. value
        vim.cmd(full_cmd)
      end
    end
  end
end

M.set_popup_menu "default"

require("autocommands").add {
  { "FileType", "BufEnter" },
  {
    pattern = "*",
    callback = function() M.set_popup_menu(vim.o.filetype) end,
  },
}

return M
