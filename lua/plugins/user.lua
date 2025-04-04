-- You can also add or configure plugins by creating files in this `plugins/` folder

---@type LazySpec
return {

  "andweeb/presence.nvim",

  { -- TODO: Look into completely
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function(_, opts)
      ---@type snacks.Config
      vim.tbl_deep_extend("force", opts, {
        bigfile = { enabled = true },
        rename = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        input = { enabled = true },
        image = {
          enabled = true,
          doc = { enabled = true },
          math = {
            enabled = true,
            latex = {
              font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
              -- for latex documents, the doc packages are included automatically,
              -- but you can add more packages here. Useful for markdown documents.
              packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
              tpl = [[
                \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
                \usepackage{${packages}}
                \begin{document}
                ${header}
                { \${font_size} \selectfont
                  \color[HTML]{${color}}
                ${content}}
                \end{document}]],
            },
          },
        },
        ---@type snacks.picker.Config
        picker = {
          -- exclude = {
          --   "node_modules",
          --   ".git",
          --   "__pycache__",
          --   "target",
          -- },
          win = { input = { keys = { ["<esc>"] = { "close", mode = { "n", "i" } } } } },
        },
      })
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
}
