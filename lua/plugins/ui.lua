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
    opts = {
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
    },
    init = function(plugin) vim.g.neominimap = plugin.opts end,
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

  -- {
  --   "folke/edgy.nvim",
  --   opts = function(_, opts)
  --     opts.animate = { enabled = false }
  --     opts.left = {
  --       {
  --         title = "Files",
  --         ft = "neo-tree",
  --         filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
  --         pinned = true,
  --         open = "Neotree position=left filesystem",
  --         size = { height = 0.5 },
  --       },
  --       {
  --         title = "Buffers",
  --         ft = "neo-tree",
  --         filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end,
  --         pinned = true,
  --         collapsed = false,
  --         open = "Neotree position=top buffers",
  --       },
  --       -- "neo-tree",
  --     }
  --
  --     opts.right = {
  --       {
  --         ft = "aerial",
  --         title = "Symbol Outline",
  --         pinned = true,
  --         open = function() require("aerial").open() end,
  --         size = { width = 15 },
  --       },
  --       {
  --         ft = "neominimap",
  --         title = "Neominimap",
  --         pinned = true,
  --         open = function() require("neominimap.api").enable() end,
  --         size = { width = 15 },
  --       },
  --     }
  --
  --     return opts
  --   end,
  -- },
}
