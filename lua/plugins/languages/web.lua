---@type LazySpec
return {
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "scss", "html", "javascript" },
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "htmldjango", "typescriptreact", "tsx", "vue", "svelte", "php", "rescript" },
    config = function() require("nvim-ts-autotag").setup() end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    ft = {
      "javascript",
      "typescript",
      "typescriptreact",
      "tsx",
      "css",
      "scss",
      "php",
      "html",
      "htmldjango",
      "svelte",
      "vue",
      "astro",
      "handlebars",
      "glimmer",
      "graphql",
      "lua",
      "python",
    },
    event = "BufRead",
  },
}
