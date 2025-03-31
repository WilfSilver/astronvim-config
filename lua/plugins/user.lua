-- You can also add or configure plugins by creating files in this `plugins/` folder

---@type LazySpec
return {

  "andweeb/presence.nvim",

  { -- TODO: Look into completely
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      rename = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
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
    },
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
}
