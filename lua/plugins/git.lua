local wk = require "which-key"

---@type LazySpec
return {
  { -- Managed by astrovim
    "lewis6991/gitsigns.nvim",
    config = function(_, opts)
      local gs = require "gitsigns"
      gs.setup(opts)

      wk.add {
        {
          "<Leader>gp",
          function() gs.nav_hunk("prev", { navigation_message = false }) end,
          desc = "Preview Hunk",
        },
        { "<Leader>gr", gs.reset_hunk, desc = "Reset Hunk" },
        { "<Leader>gR", gs.reset_buffer, desc = "Reset Buffer" },
        { "<Leader>gs", gs.stage_hunk, desc = "Stage/Undo Stage Hunk" },
        {
          "<Leader>gj",
          function() gs.nav_hunk("next", { navigation_message = false }) end,
          desc = "Next Hunk",
        },
        { "<Leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff" },
      }
    end,
  },

  {
    "f-person/git-blame.nvim",
    event = "User AstroGitFile",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 0
    end,
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    event = "User AstroGitFile",
    config = function(_, opts)
      require("neogit").setup(opts)
      wk.add {
        { "<Leader>gB", function() require("neogit").open { "branch" } end, desc = "Branch options" },
        { "<Leader>gf", function() require("neogit").open { kind = "auto" } end, desc = "NeoGit" },
        { "<Leader>gl", function() require("neogit").open { "log" } end, desc = "Git log" },
      }
    end,
  },

  {
    "sindrets/diffview.nvim",
    event = "User AstroGitFile",
  },

  -- {
  -- 	"pwntester/octo.nvim",
  -- 	event = "VimEnter",
  -- 	requires = {
  -- 		"nvim-lua/plenary.nvim",
  -- 		"nvim-telescope/telescope.nvim",
  -- 		"nvim-tree/nvim-web-devicons",
  -- 	},
  -- 	config = function()
  -- 		require("octo").setup()
  -- 	end,
  -- },
}
