-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = function(_, opts)
      -- Make sure to use the names found in `:Mason`
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",
        "fourmolu",
        "black",

        "biome",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",
      })

      -- TODO: I would like to have these installed and only enable them
      -- when the project is configured for them

      -- I use biome instead
      local remove = { eslint = true, prettierd = true }

      for i = #opts.ensure_installed, 1, -1 do
        if remove[opts.ensure_installed[i]] then table.remove(opts.ensure_installed, i) end
      end
    end,
  },
}
