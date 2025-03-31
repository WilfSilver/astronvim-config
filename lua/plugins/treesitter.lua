-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    auto_install = true,
    rainbow = { enable = true },
    ignore_install = { "perl" },
    ensure_installed = {
      "lua",
      "vim",
      "regex",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
