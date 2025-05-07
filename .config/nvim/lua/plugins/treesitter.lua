return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {
        "c",
        "javascript",
        "typescript",
        "markdown",
        "astro",
        "asm",
        "bash",
        "go",
        "cpp",
        "css",
        "dockerfile",
        "lua",
        "python",
        "html",
        "zig",
        "rust",
        "tsx",
        "vim",
        "vimdoc",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
