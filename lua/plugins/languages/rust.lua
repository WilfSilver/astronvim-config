local wk = require "which-key"

-- This is handled by the community

---@type LazySpec
return { -- Managed by the community but I wanted to add keybindings
  "Saecki/crates.nvim",
  config = function(_, opts)
    local crates = require "crates"
    crates.setup(opts)

    wk.add {
      { "<localleader>C", group = "Crates options" },
      {
        mode = "n",
        { "<localleader>Ct", crates.toggle, desc = "Toggle" },
        { "<localleader>Cr", crates.reload, desc = "Reload" },
        { "<localleader>Cv", crates.show_versions_popup, desc = "Show Versions popup" },
        { "<localleader>Cf", crates.show_features_popup, desc = "Show features popup" },
        { "<localleader>Cd", crates.show_dependencies_popup, desc = "Show dependencies popup" },
        { "<localleader>Cu", crates.update_crates, desc = "Update crate" },
        { "<localleader>Ca", crates.update_all_crates, desc = "Update all crates" },
        { "<localleader>CU", crates.upgrade_crates, desc = "Upgrade crate" },
        { "<localleader>CA", crates.upgrade_all_crates, desc = "Upgrade all crates" },
        { "<localleader>Ce", crates.expand_plain_crate_to_inline_table, desc = "Expand crate to table" },
        { "<localleader>CE", crates.extract_crate_into_table, desc = "Extract crate into table" },
        { "<localleader>CH", crates.open_homepage, desc = "Open Homepage" },
        { "<localleader>CR", crates.open_repository, desc = "Open Repository" },
        { "<localleader>CD", crates.open_documentation, desc = "Open Documentation" },
        { "<localleader>CC", crates.open_crates_io, desc = "Open crates.io" },
      },
      {
        mode = "v",

        { "<localleader>Cu", crates.update_crates, desc = "" },
        { "<localleader>CU", crates.upgrade_crates, desc = "" },
      },
    }
  end,
}
