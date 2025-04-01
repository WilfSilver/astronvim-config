-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
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
        colorcolumn = { 80 },
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
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["<S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-h>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

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
        ["<C-/>"] = {
          function()
            -- Gets the position of the cursor for the current window
            local line = vim.fn.line "."
            require("mini.comment").toggle_lines(line, line, {})
          end,
          desc = "Toggle comment line",
        },

        ["<C-up>"] = false,
        ["<C-down>"] = false,

        ["<C-t>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },

        ["<Leader>lR"] = { "<cmd>LspRestart<cr>", desc = "Restart server" },
        ["<Leader>X"] = { ":xa<cr>", desc = "Save all and quit" },

        ["<C-z>"] = "u",
        ["<C-a>"] = { "ggVG", desc = "Select all" },
        ["<C-p>"] = {
          function() require("snacks").picker.files {} end,
          desc = "Find file",
        },
        ["<ESC><ESC>"] = { "<cmd>nohlsearch<CR>", desc = "Remove highlights" },

        ["<M-S-j>"] = { "<cmd>t.<CR>", desc = "Copy line down" },
        ["<M-S-k>"] = { "<cmd>t-<CR>", desc = "Copy line up" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },
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
  },
}
