local ac = require "autocommands"
local util = require "util"

---@type LazySpec
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      event_handlers = {

        {
          event = "file_open_requested",
          handler = function()
            -- auto close
            -- vim.cmd("Neotree close")
            -- OR
            require("neo-tree.command").execute { action = "close" }
          end,
        },
      },
    },
  },

  {
    "Isrothy/neominimap.nvim",
    config = function() end,
    init = function()
      vim.g.neominimap = {
        auto_enable = true,
        layout = "split",
        split = {
          minimap_width = 15,
          close_if_last_window = true,
        },
        click = { enable = true },
        search = { enable = true },
        mark = { enable = true },
        buf_filter = function(bufnr) return require("astrocore.buffer").is_valid(bufnr) end,
      }
    end,
  },

  {
    "nacro90/numb.nvim",
    event = "User AstroFile",
    config = function()
      require("numb").setup {
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      }
    end,
  },

  {
    "v1nh1shungry/error-lens.nvim",
    event = "User AstroFile",
    opts = {},
  },

  { "nvim-tree/nvim-web-devicons", opts = {} },
}
