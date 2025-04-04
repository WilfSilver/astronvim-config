--- This is an alteration of the AstroUI mode

---@type LazySpec
return {
  "rebelot/heirline.nvim",

  opts = function(_, opts)
    local status = require "astroui.status"

    opts.statusline = { -- statusline
      hl = { fg = "fg", bg = "bg" },
      status.component.mode {
        mode_text = { padding = { left = 1, right = 1 } },
      },
      status.component.git_branch {
        -- TODO: Change background colour based on if branch changed
        surround = {
          separator = "left",
          -- color = function() return { main = status.hl.mode_bg(), right = "blank_bg" } end,
        },
      },
      status.component.file_info(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      status.component.git_diff(),
      status.component.diagnostics(),
      status.component.lsp(),
      status.component.virtual_env(),
      -- status.component.treesitter(),
      status.component.nav {
        scrollbar = false,
      },
      status.component.mode { surround = { separator = "right" } },
    }

    -- opts.statuscolumn = { -- statuscolumn
    --   init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
    --   status.component.foldcolumn(),
    --   status.component.numbercolumn(),
    --   status.component.signcolumn(),
    -- }
  end,
}
