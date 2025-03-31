---@type LazySpec
return { -- Managed by community
  "lervag/vimtex",
  init = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_method = "tectonic"
    vim.g.vimtex_compiler_progname = "nvr"

    vim.g.vimtex_compiler_method = "generic"
    vim.g.vimtex_compiler_generic = {

      command = "ls *.tex | entr -n -c tectonic /_ --synctex --keep-logs",
    }
  end,
}
