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
    "echasnovski/mini.map",
    branch = "stable",
    event = "User AstroFile",
    config = function()
      local map = require "mini.map"

      map.setup {
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic {
            error = "DiagnosticFloatingError",
            warn = "DiagnosticFloatingWarn",
            info = "DiagnosticFloatingInfo",
            hint = "DiagnosticFloatingHint",
          },
        },
        symbols = {
          encode = map.gen_encode_symbols.dot "4x2",
        },
        window = {
          focusable = true,
          side = "right",
          width = 10,
          winblend = 0,
          show_integration_count = false,
        },
      }

      ac.on_files("*", function()
        map.open()
        vim.b.minimap_disable = false
        vim.g.minimap_open = true
      end, function()
        map.close()
        vim.b.minimap_disable = true
      end)

      -- Close the mini map when when the cursor is close to it
      ac.add {
        { "CursorMoved", "CursorMovedI" },
        {
          pattern = "*",
          callback = function()
            if not ac.is_in_sys_buffer() and not vim.b.minimap_disable then
              local col = util.get_relative_cursor_pos()[2]

              if col >= vim.o.columns - 25 then
                if vim.g.minimap_open then
                  map.close()
                  vim.g.minimap_open = false
                end
              else
                if not vim.g.minimap_open then
                  vim.g.minimap_open = true
                  map.open()
                end
              end
            end
          end,
        },
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
