return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle UndoTree" },
  },
  init = function()
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}

