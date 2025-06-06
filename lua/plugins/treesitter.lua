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
    highlight = {
      -- See https://github.com/lervag/vimtex/issues/2469
      additional_vim_regex_highlighting = { "latex" },
    },
  },
}
