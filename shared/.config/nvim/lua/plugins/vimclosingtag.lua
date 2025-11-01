return {
  "alvan/vim-closetag",
  ft = { "html", "xhtml", "javascriptreact", "typescriptreact" },
  config = function()
    vim.g.closetag_filenames = "*.html,*.xhtml,*.jsx,*.tsx"
    vim.g.closetag_xhtml_filenames = "*.xhtml,*.jsx,*.tsx"
    vim.g.closetag_filetypes = "html,xhtml,javascriptreact,typescriptreact"
    vim.g.closetag_show_shortcut = 1
    vim.g.closetag_shortcut = ">"
  end,
}
