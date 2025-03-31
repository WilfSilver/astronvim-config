-- TODO: https://github.com/benlubas/molten-nvim/blob/main/docs/Notebook-Setup.md

---@type LazySpec
return {
  {
    dependencies = {
      "kana/vim-textobj-user",
      "kana/vim-textobj-line",
      "GCBallesteros/vim-textobj-hydrogen",
    },
    "GCBallesteros/jupytext.vim",
    ft = { "ipynb" },
    init = function()
      vim.g.jupytext_enable = true
      vim.g.jupytext_fmt = "py"
      vim.g.jupytext_style = "hydrogen"
    end,
  },

  { "untitled-ai/jupyter_ascending.vim" },
}
