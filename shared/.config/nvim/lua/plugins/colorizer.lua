return {
  "norcalli/nvim-colorizer.lua",
  event = "BufReadPost",  -- only load when a file is opened
  config = function()
    require("colorizer").setup({
      "*", -- Enable for all filetypes
    }, {
      names = false, -- Disable named colors like "blue"
    })
  end,
}

