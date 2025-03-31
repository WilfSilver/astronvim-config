local ac = require "autocommands"
local wk = require "which-key"

---@type LazySpec
return {
  { "tpope/vim-repeat" },

  {
    "felipec/vim-sanegx",
    event = "BufRead",
  },

  {
    "Pocco81/auto-save.nvim",
    event = { "User AstroFile" },
    config = function()
      local as = require "auto-save"
      as.setup {
        trigger_events = { "InsertLeave" },
        enabled = true,
        debounce_delay = 1000,
      }

      ac.add {
        { "FileType", "BufEnter" },
        {
          desc = "Turns off autosave on jupyter notebooks",
          pattern = "*.ipynb",
          callback = function() as.off() end,
        },
      }
      wk.add {
        mode = "n",
        { "<Leader>W", require("auto-save").toggle, desc = "Toggle Auto Save" },
      }
    end,
  },

  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit",
          "gitrebase",
          "svn",
          "hgcommit",
        },
        lastplace_open_folds = true,
      }
    end,
  },

  -- TODO: Fix this plugin, its meant to fix the keys
  {
    "mrjones2014/legendary.nvim",
    -- since legendary.nvim handles all your keymaps/commands,
    -- its recommended to load legendary.nvim before other plugins
    priority = 10000,
    lazy = false,
    -- sqlite is only needed if you want to use frecency sorting
    dependencies = { "kkharji/sqlite.lua" },
  },

  { "nvim-lua/plenary.nvim" },
}
