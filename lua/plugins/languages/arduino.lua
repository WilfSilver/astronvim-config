---@type LazySpec
return {
  "stevearc/vim-arduino",
  event = "User AstroFile",
  cmd = {
    "ArduinoAttach",
    "ArduinoVerify",
    "ArduinoUpload",
    "ArduinoUploadAndSerial",
    "ArduinoChooseBoard",
    "ArduinoChoosePort",
    "ArduinoChooseProgrammer",
    "ArduinoInfo",
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings

        local prefix = "<Leader>A"
        maps.n[prefix] = { desc = "Arduino" }

        maps.n[prefix .. "a"] = { "<cmd>ArduinoAttach<CR>", desc = "Attatch" }
        maps.n[prefix .. "i"] = { "<cmd>ArduinoInfo<CR>", desc = "Info" }
        maps.n[prefix .. "m"] = { "<cmd>ArduinoVerify<CR>", desc = "Verify" }
        maps.n[prefix .. "u"] = { "<cmd>ArduinoUpload<CR>", desc = "Upload" }
        maps.n[prefix .. "d"] = { "<cmd>ArduinoUploadAndSerial<CR>", desc = "Upload + Serial" }
        maps.n[prefix .. "b"] = { "<cmd>ArduinoChooseBoard<CR>", desc = "Choose Board" }
        maps.n[prefix .. "p"] = { "<cmd>ArduinoChooseProgrammer<CR>", desc = "Choose Programmer" }
      end,
    },
  },
}
