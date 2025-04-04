---@type LazySpec
return {
  { -- Managed by astronvim
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      -- Setting keybindings work slightly differently to other functions
      opts.on_attach = require("astrocore").patch_func(opts.on_attach, function(original_on_attach, bufnr)
        original_on_attach(bufnr)

        -- This is used by neogit for logs
        vim.keymap.del("n", "<Leader>gl", { buffer = bufnr })

        local astrocore = require "astrocore"
        local prefix, maps = "<Leader>g", astrocore.empty_map_table()

        maps.n[prefix .. "D"] =
          { function() require("gitsigns").blame_line { full = true } end, desc = "View full Git blame" }

        maps.n[prefix .. "L"] = { function() require("gitsigns").blame_line() end, desc = "View Git blame" }

        astrocore.set_mappings(maps, { buffer = bufnr })
      end)
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

  { -- Handled by the community mostly
    "NeogitOrg/neogit",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings

          local prefix = "<Leader>g"
          -- This is also set by gitsigns (in astronvim config) for each buffer,
          -- instead we are just gunna set it globally
          maps.n[prefix] = { desc = require("astroui").get_icon("Git", 1, true) .. "Git" }

          -- Disable community keybindings
          maps.n[prefix .. "n"] = false
          maps.n[prefix .. "nt"] = false
          maps.n[prefix .. "nc"] = false
          maps.n[prefix .. "nd"] = false
          maps.n[prefix .. "nk"] = false

          maps.n[prefix .. "n"] = { desc = require("astroui").get_icon("Neogit", 1, true) .. "Neogit" }
          maps.n[prefix .. "B"] = {
            function() require("neogit").open { "branch" } end,
            desc = require("astroui").get_icon("Neogit", 1, true) .. "Branch options",
          }
          maps.n[prefix .. "f"] = {
            function() require("neogit").open { kind = "auto" } end,
            desc = require("astroui").get_icon("Neogit", 1, true) .. "Neogit",
          }
          maps.n[prefix .. "l"] = {
            function() require("neogit").open { "log" } end,
            desc = require("astroui").get_icon("Neogit", 1, true) .. "Git log",
          }
        end,
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    event = "User AstroGitFile",
  },
}
