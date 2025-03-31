local wk = require "which-key"
local ac = require "autocommands"
local util = require "util"

---@type LazySpec
return {
  {
    -- Managed by Astrovim
    "akinsho/toggleterm.nvim",
    opts = function(_, opts)
      opts.direction = "tab"
      opts.open_mapping = "<C-t>"
      opts.on_open = function() vim.cmd "setlocal scrollback=300" end
    end,
  },

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

  -- TODO: Improve key bindings
  { -- Managed by community
    "mg979/vim-visual-multi",
    event = "User AstroFile",
    opts = function(_, opts)
      local maps = assert(opts.mappings)
      maps.n["<C-S-j>"] = { "<C-u>call vm#commands#add_cursor_down(0, v:count1)<cr>", desc = "Add cursor below" }
      maps.n["<C-S-k>"] = { "<C-u>call vm#commands#add_cursor_up(0, v:count1)<cr>", desc = "Add cursor above" }
      maps.n["<C-S-k>"] = { "<C-u>call vm#commands#add_cursor_up(0, v:count1)<cr>", desc = "Add cursor above" }
      maps.n["<C-LeftMouse>"] = { "<Plug>(VM-Mouse-Cursor)", desc = "Add cursor at mouse" }
      maps.n["<C-RightMouse>"] = { "<Plug>(VM-Mouse-Word)", desc = "Add word at mouse" }

      opts.options.g.VM_leader = "\\"
      opts.options.g.VM_set_statusline = 0
      opts.options.g.VM_theme = "ocean"
      opts.options.g.VM_maps = {
        ["Switch Mode"] = "v",
      }
    end,
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
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = {
              function(i) require("telescope.actions").move_selection_next(i) end,
              type = "action",
              opts = { nowait = true, silent = true },
            },
            ["<C-k>"] = {
              function(i) require("telescope.actions").move_selection_previous(i) end,
              type = "action",
              opts = { nowait = true, silent = true },
            },
            ["<esc>"] = function(i) require("telescope.actions").close(i) end,
          },
        },
      },
    },
  },
}
