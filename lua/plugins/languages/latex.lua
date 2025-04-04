---@type LazySpec
return { -- Managed by community
  "lervag/vimtex",
  dependencies = {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      options = {
        g = {
          vimtex_view_method = "zathura",
          vimtex_compiler_progname = "nvr",

          vimtex_compiler_method = "generic",
          vimtex_compiler_generic = {
            -- This assumes that you have run
            -- tectonic -X init
            -- command = "tectonic -X watch",
            command = "ls @tex | entr -nc tectonic /_ --synctex --keep-logs",
          },
        },
      },
    },
  },
}
