-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local Snacks = require "snacks"
    ---@type AstroCoreOpts
    return vim.tbl_deep_extend("force", opts, {
      -- Configure core features of AstroNvim
      features = {
        large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
        autopairs = true, -- enable autopairs at start
        cmp = true, -- enable completion at start
        diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
        highlighturl = true, -- highlight URLs at start
        notifications = true, -- enable notifications at start
      },
      -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
      -- passed to `vim.filetype.add`
      filetypes = {
        -- see `:h vim.filetype.add` for usage
        extension = {
          -- foo = "fooscript",
        },
        filename = {
          -- [".foorc"] = "fooscript",
        },
        pattern = {
          -- [".*/etc/foo/.*"] = "fooscript",
        },
      },
      -- vim options can be configured here
      options = {
        opt = { -- vim.opt.<key>
          shiftwidth = 2,
          tabstop = 2,
          relativenumber = true, -- sets vim.opt.relativenumber
          number = true, -- sets vim.opt.number
          smarttab = true,
          list = true,
          lcs = vim.opt.lcs + "space:·",
          spell = false, -- sets vim.opt.spell
          signcolumn = "yes", -- sets vim.opt.signcolumn to yes
          wrap = true, -- sets vim.opt.wrap
          -- colorcolumn = { 80 }, managed smartcolumn.nvim
          scrolloff = 10,

          foldmethod = "expr",
          foldexpr = "nvim_treesitter#foldexpr()",
          foldenable = false,

          clipboard = "unnamedplus",
          conceallevel = 0,
          guifont = "FiraCode:h20",
        },
        g = { -- vim.g.<key>
          -- configure global vim variables (vim.g)
          -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
          -- This can be found in the `lua/lazy_setup.lua` file
        },
      },
      -- Mappings can be configured through AstroCore as well.
      -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
      mappings = {
        -- first key is the mode
        n = {
          -- Some shuffling remixing to make it feel more like lunarvim
          ["<Leader>fA"] = opts.mappings.n["<Leader>fa"],
          ["<Leader>fa"] = opts.mappings.n["<Leader>fs"],
          ["<Leader>fs"] = {
            function() Snacks.picker.lsp_workspace_symbols { tree = true } end,
            desc = "Find Workspace Symbols",
          },

          ["<Leader>fC"] = opts.mappings.n["<Leader>ft"],
          ["<Leader>ft"] = opts.mappings.n["<Leader>fw"],
          ["<Leader>fw"] = opts.mappings.n["<Leader>fc"],
          ["<Leader>fc"] = opts.mappings.n["<Leader>fC"],

          ["<Leader>lo"] = opts.mappings.n["<Leader>lS"],
          ["<Leader>lS"] = false,
          ["<Leader>lG"] = false, -- For some reason this doesn't really work for me (see <Leader>fs for alternative)

          ["<Leader>bh"] = opts.mappings.n["<Leader>bl"],
          ["<Leader>bl"] = opts.mappings.n["<Leader>br"],
          ["<Leader>br"] = false,

          -- navigate buffer tabs
          ["<S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["<S-h>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

          -- My improved C-s handling if it hasn't been saved before
          ["<C-s>"] = {
            function()
              local name = vim.api.nvim_buf_get_name(0)

              if name == "" then
                name = vim.fn.input {
                  prompt = "Path to save to: ",
                  default = vim.fn.getcwd() .. "/",
                  completion = "file",
                }
                if name ~= "" then vim.cmd("write " .. name) end
              else
                vim.cmd "update"
              end
            end,
            desc = "Save file",
          },

          -- Mini.comment is managed by the community :)
          -- TODO: Move this into a separate file (for use of referencing to mini.comment)
          ["<C-/>"] = {
            function()
              -- Gets the position of the cursor for the current window
              local line = vim.fn.line "."
              require("mini.comment").toggle_lines(line, line, {})
            end,
            desc = "Toggle comment line",
          },

          -- This is implemented by multi-cusors (community) and it clashes with
          -- others do disable (I use C-S-j anyway)
          ["<C-up>"] = false,
          ["<C-down>"] = false,

          ["<Leader>lR"] = { "<cmd>LspRestart<cr>", desc = "Restart server" },

          -- Terminal improvements
          ["<C-t>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },

          -- Random nicities found in other ides
          ["<C-z>"] = { "u", desc = "Undo" },
          ["<C-a>"] = { "ggVG", desc = "Select all" },
          ["<C-p>"] = opts.mappings.n["<Leader>ff"],
          ["<ESC><ESC>"] = { "<cmd>nohlsearch<CR>", desc = "Remove highlights" },

          ["<M-S-j>"] = { "<cmd>t.<CR>", desc = "Copy line down" },
          ["<M-S-k>"] = { "<cmd>t-<CR>", desc = "Copy line up" },

          ["<Leader>bd"] = {
            function()
              require("astroui.status.heirline").buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Close buffer from tabline",
          },
        },
        i = {
          ["<M-S-j>"] = { "<cmd>t.<CR>", desc = "Copy line down" },
          ["<M-S-k>"] = { "<cmd>t-<CR>", desc = "Copy line up" },
          ["<C-/>"] = {
            function()
              -- Gets the position of the cursor for the current window
              local line = vim.fn.line "."
              require("mini.comment").toggle_lines(line, line, {})
            end,
            desc = "Toggle comment line",
          },
        },
        v = {
          -- Keep selection when changing the indentation
          [">"] = { ">gv" },
          ["<"] = { "<gv" },

          ["<C-/>"] = {
            function()
              -- Gets the position of the cursor for the current window
              require("mini.comment").toggle_lines(vim.fn.line "v", vim.fn.line ".", {})
            end,
            desc = "Toggle comment",
          },

          ["<M-S-j>"] = { ":'<,'>t'<-<CR>gv", desc = "Copy selected lines down" },
          ["<M-S-k>"] = { ":'<,'>t'><CR>gv", desc = "Copy selected lines up" },
        },
      },
    })
  end,
}
