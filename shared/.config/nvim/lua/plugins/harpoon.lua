return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    local map = vim.keymap.set
    map("n", "<leader>a", function()
      harpoon:list():append()
    end, { desc = "Harpoon Add File" })
    map("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon UI" })
    map("n", "<leader>1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon to File 1" })
    map("n", "<leader>2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon to File 2" })
    map("n", "<leader>3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon to File 3" })
    map("n", "<leader>4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon to File 4" })
  end,
}
