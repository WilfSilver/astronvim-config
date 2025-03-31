local wk = require "which-key"

---@type LazySpec
return {
  "stevearc/vim-arduino",
  ft = "arduino",
  config = function()
    -- TODO: update commands to use snacks?
    wk.add {
      { "<Leader>a", group = "Arduino" },
      {
        mode = "n",
        { "<Leader>aa", "<cmd>ArduinoAttach<CR>", desc = "Attatch" },
        { "<Leader>am", "<cmd>ArduinoVerify<CR>", desc = "Verify" },
        { "<Leader>au", "<cmd>ArduinoUpload<CR>", desc = "Upload" },
        { "<Leader>ad", "<cmd>ArduinoUploadAndSerial<CR>", desc = "Upload + Serial" },
        { "<Leader>ab", "<cmd>ArduinoChooseBoard<CR>", desc = "Choose Board" },
        { "<Leader>ap", "<cmd>ArduinoChooseProgrammer<CR>", desc = "Choose Programmer" },
      },
    }
  end,
}
