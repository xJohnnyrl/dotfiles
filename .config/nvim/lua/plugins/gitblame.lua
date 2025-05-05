return {
  "f-person/git-blame.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.g.gitblame_enabled = 1
  end,
}

