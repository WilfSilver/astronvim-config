local wk = require "which-key"
local ac = require "autocommands"
local util = require "util"

---@type LazySpec
return {
  {
    "ntpeters/vim-better-whitespace",
    event = "User AstroFile",
    init = function()
      vim.g.strip_whitelines_at_eof = true
      vim.g.show_spaces_that_precede_tabs = true
      vim.g.strip_whitespace_on_save = false -- has annoying popup

      -- You can't extend vim.g.better_whitespace_filetypes_blacklist for some
      -- reason, so this is th workaround
      local ft_blacklist = util.tbl_shallow_copy(ac.exclude_ft)
      util.list_merge_into(ft_blacklist, {
        "diff",
        "git",
        "gitcommit",
        "unite",
        "qf",
        "help",
        "markdown",
        "toggleterm",
        "snacks_dashboard",
      })
      vim.g.better_whitespace_filetypes_blacklist = ft_blacklist

      wk.add {
        "<Leader>!",
        "<cmd>StripWhitespace<CR>",
        desc = "Strip Whitespace",
      }

      -- For some reaosn it creates this key map if not set already
      -- keys.remove_basic_key('n', '<leader>s')
    end,
  },

  {
    "tpope/vim-surround",
    config = function()
      -- Label the keys
      wk.add({ desc = "Change surround from - to" }, { mode = "n", prefix = "cs" })
      wk.add({ desc = "Tag (if html tag)" }, { mode = "n", prefix = "cst" })
      wk.add({ desc = "Add Surround" }, { mode = "n", prefix = "ys" })
      wk.add({ desc = "Remove Surround" }, { mode = "n", prefix = "ds" })
      wk.add({ desc = "Surround Line" }, { mode = "n", prefix = "yss" })
      wk.add({ desc = "Surround Inner..." }, { mode = "n", prefix = "ysi" })
      wk.add({ desc = "Word" }, { mode = "n", prefix = "ysiw" })
      -- keys.label("v", "Add Surround")
      -- vim.o.timeoutlen = 500
    end,
  },

  -- TODO: Improve key bindings
  {
    "mg979/vim-visual-multi",
    event = "User AstroFile",
    init = function()
      vim.g.VM_leader = "\\"
      vim.g.VM_theme = "ocean"
      vim.g.VM_set_statusline = 0

      -- For these maps to work, it needs to be configured in your terminal
      -- emulator, see: Please see https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/
      vim.g.VM_maps = {
        ["Add Cursor Down"] = "<C-S-j>", -- start selecting down
        ["Add Cursor Up"] = "<C-S-k>", -- start selecting up
        ["Switch Mode"] = "v",
      }
    end,
    keys = {
      { "<C-LeftMouse>", "<Plug>(VM-Mouse-Cursor)", desc = "Add cursor at mouse" },
      { "<C-RightMouse>", "<Plug>(VM-Mouse-Word)", desc = "Add word at mouse" },
    },
  },

  {
    "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function() require("leap").add_default_mappings() end,
  },

  {
    "ggandor/flit.nvim",
    dependencies = {
      "ggandor/leap.nvim",
      "tpope/vim-repeat",
    },
    config = function() require("flit").setup() end,
  },

  {
    "AckslD/nvim-trevJ.lua",
    config = function() require("trevj").setup() end,
    keys = {
      {
        "<leader>lL",
        function() require("trevj").format_at_cursor() end,
        mode = { "n" },
        desc = "Format under cursor",
      },
    },
  },

  {
    -- TODO: Improve config + add keybindings
    -- E.g. wrap output text to 80 or something, set pwd
    "metakirby5/codi.vim",
    init = function()
      vim.g.codi = {
        width = 80,
        virtual_text = false,
      }
    end,
    cmd = { "Codi", "CodiNew" },
  },

  -- Managed by community
  -- TODO: Add back keys
  -- {
  --   "windwp/nvim-spectre",
  --   config = function() require("spectre").setup() end,
  --   keys = { -- TODO: Fix
  --     ["<leader>fs"] = {
  --       function() require("spectre").open_visual { select_word = true } end,
  --       desc = "Search current word",
  --     },
  --     ["<leader>fw"] = {
  --       function() require("spectre").open_visual { select_word = true } end,
  --       desc = "Search current word",
  --       mode = "n",
  --     },
  --     ["<leader>fp"] = {
  --       function() require("spectre").open_file_search { select_word = true } end,
  --       desc = "Search on current file",
  --       mode = "n",
  --     },
  --     ["<Leader>f"] = { group = "Find", mode = "v" },
  --     ["<Leader>fw"] = {
  --       function() require("spectre").open_visual() end,
  --       desc = "Search current word",
  --       mode = "v",
  --     },
  --     ["<Leader>fp"] = {
  --       function() require("spectre").open_file_search() end,
  --       desc = "Search current file",
  --       mode = "v",
  --     },
  --   },
  -- },

  -- TODO: Fix
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
  },

  {
    "simrat39/symbols-outline.nvim",
    config = function()
      local so = require "symbols-outline"
      so.setup {
        autofold_depth = 3,
        keymaps = {
          -- These keymaps can be a string or a table for multiple keys
          close = { "<Esc>", "q" },
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "<C-space>",
          toggle_preview = "K",
          rename_symbol = "r",
          code_actions = "a",
          fold = "h",
          unfold = "l",
          fold_all = "W",
          unfold_all = "E",
          fold_reset = "R",
        },
      }
    end,
    keys = {
      ["<Leader>lo"] = {
        function() require("symbols-outline").toggle_outline() end,
        mode = { "n" },
        desc = "Open Outline",
      },
    },
  },

  {
    "npxbr/glow.nvim",
    ft = { "markdown" },
    config = function()
      require("glow").setup()
      -- TODO: Bring this logic back

      -- keys.add_key_in_file("n", "markdown", "P", { "<cmd>Glow<cr>", "Preview file" })
    end,
  },

  { "echasnovski/mini.nvim", version = "*" },

  {
    "Vigemus/iron.nvim",
    opts = {
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "zsh" },
          },

          haskell = {
            command = function(meta)
              local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
              -- call `require` in case iron is set up before haskell-tools
              return require("haskell-tools").repl.mk_repl_cmd(file)
            end,
          },
        },
        -- How the repl window will be displayed
        -- See below for more information
        -- repl_open_cmd = require("iron.view").bottom(40),
      },
      -- -- Iron doesn't set keymaps by default anymore.
      -- -- You can set them here or manually add keymaps to the functions in iron.core
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    },
    config = function(_, opts)
      local iron = require "iron.core"

      iron.setup(opts)

      wk.add {
        "<leader>R",
        mode = { "n", "v" },
        group = "Iron Repl",
        extend = true,
        S = {
          group = "Send",
          M = { iron.send_motion, "Motion" },
          v = { iron.visual_send, "Visual" },
          f = { iron.send_file, "File" },
          l = { iron.send_line, "Line" },
          b = { iron.send_until_cursor, "Until Cursor" },
          m = { iron.send_mark, "Until Mark" },
        },
        m = { iron.send_mark, "Mark Motion" },
        M = { iron.send_mark, "Remove Mark" },
        v = { iron.send_mark, "Mark Visual" },
        q = { iron.exit, "Exit" },
        i = { iron.interrupt, "Interrupt" },
        c = { iron.clear, "Clear" },
      }
    end,
    cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
    -- TODO: Show this on which-key as an option
    keys = {
      ["<leader>R"] = {
        mode = { "n", "v" },
        group = "Iron Repl",
        s = { "<cmd>IronRepl<cr>", "Start" },
        r = { "<cmd>IronRestart<cr>", "Restart" },
        f = { "<cmd>IronFocus<cr>", "Focus" },
        h = { "<cmd>IronHide<cr>", "Hide" },
      },
    },
  },

  -- Although snacks.picker is mostly used, this is just here for backup
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = {
              function() require("telescope.actions").move_selection_next() end,
              type = "action",
              opts = { nowait = true, silent = true },
            },
            ["<C-k>"] = {
              function() require("telescope.actions").move_selection_previous() end,
              type = "action",
              opts = { nowait = true, silent = true },
            },
            ["<esc>"] = function() require("telescope.actions").close() end,
          },
        },
      },
    },
  },
}
