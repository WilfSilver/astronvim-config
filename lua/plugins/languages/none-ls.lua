-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- opts variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

    -- Only insert new sources, do not replace the existing ones
    -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- NOTE: All of these are found in the mason ensure_installed

      -- Formatters
      -- null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.biome.with {
      --   args = {
      --     "check",
      --     "--apply-unsafe",
      --     "--formatter-enabled=true",
      --     "--organize-imports-enabled=true",
      --     "--skip-errors",
      --     "$FILENAME",
      --   },
      -- },
      -- null_ls.builtins.formatting.google_java_format,
      -- null_ls.builtins.formatting.fourmolu,
      null_ls.builtins.formatting.black,

      -- Linting
      -- null_ls.builtins.diagnostics.spellcheck,
      -- null_ls.builtins.diagnostics.vale,
    })
  end,
}
