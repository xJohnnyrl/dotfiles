return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    local config = require("ufo")
    config.setup({
      provider_selector = function(bufnr, filetype, butype)
        return { "lsp", "indent" }
      end,
    })
  end,
}
