local wk = require "which-key"
---@type LazySpec
return {
  "lervag/vimtex",
  config = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_method = "tectonic"
    vim.g.vimtex_compiler_progname = "nvr"

    vim.g.vimtex_compiler_method = "generic"
    vim.g.vimtex_compiler_generic = {

      command = "ls *.tex | entr -n -c tectonic /_ --synctex --keep-logs",
    }

    local localleader = "\\"
    wk.add {
      mode = "n",
      { localleader .. "l", group = "VimTex" },
      { localleader .. "li", desc = "Info" },
      { localleader .. "lI", desc = "Full Info" },
      { localleader .. "lt", desc = "Open Toc" },
      { localleader .. "lT", desc = "Toggle Toc" },
      { localleader .. "lv", desc = "View" },
      { localleader .. "lr", desc = "Reverse Search" },
      { localleader .. "ll", desc = "Compile" },
      { localleader .. "lk", desc = "Kill" },
      { localleader .. "lK", desc = "Stop All" },
      { localleader .. "le", desc = "Errors" },
      { localleader .. "lo", desc = "Compile Output" },
      { localleader .. "lg", desc = "Status" },
      { localleader .. "lG", desc = "Status All" },
      { localleader .. "lc", desc = "Clean" },
      { localleader .. "lC", desc = "Full Clean" },
      { localleader .. "lm", desc = "imaps list" },
      { localleader .. "lx", desc = "Reload" },
      { localleader .. "ls", desc = "Toggle Main" },
    }
  end,
}
