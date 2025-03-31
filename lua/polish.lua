-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?.lua"

local ac = require "autocommands"

ac.add_mult {
  {
    { "BufWinLeave" },
    {
      pattern = "*",
      callback = function()
        if vim.api.nvim_buf_get_name(0) ~= "" then vim.cmd "mkview" end
      end,
    },
  },
}

ac.on_open_files("*", function()
  local tab_to_space = {
    c = 4,
    cpp = 4,
    haskell = 2,
    javascript = 2,
    typescript = 2,
    typescriptreact = 2,
    glsl = 4,
    python = 4,
    perl = 4,
    rust = 4,
    zig = 4,
  }

  local size = tab_to_space[vim.o.filetype]
  if not size then size = 2 end
  vim.opt.shiftwidth = size
  vim.opt.tabstop = size
end)

ac.add_mult {
  {
    "InsertEnter",
    {
      pattern = "*",
      callback = function()
        if not ac.is_in_sys_buffer() then vim.opt.relativenumber = false end
      end,
    },
  },
  {
    "InsertLeave",
    {
      pattern = "*",
      callback = function()
        if not ac.is_in_sys_buffer() then vim.opt.relativenumber = true end
      end,
    },
  },
}

-- this template is so much worse than plain html
ac.on_open_files("htmldjango", function() vim.o.filetype = "html" end)
