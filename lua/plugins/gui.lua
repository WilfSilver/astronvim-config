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

  { -- TODO: Don't show on "snacks_dashboard",
    "echasnovski/mini.map",
    branch = "stable",
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
      -- TODO: Fix bootup not working instantly after vert split...
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
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  {
    -- TODO: Swap with folke/edgy.nvim
    -- TODO: Decide whether to keep
    -- TODO: Add the better keymaps
    "s1n7ax/nvim-window-picker",
    version = "1.*",
    config = function()
      local picker = require "window-picker"
      picker.setup {
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal" },
          },
        },
        other_win_hl_color = "#e35e4f",
      }
    end,
    keys = {
      ["<Leader>p"] = {
        function()
          local picker = require "window-picker"
          local picked_window_id = picker.pick_window() or vim.api.nvim_get_current_win()
          vim.api.nvim_set_current_win(picked_window_id)
        end,
        modes = "n",
        desc = "Pick a window",
      },
    },
  },

  {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      }
    end,
  },
}
