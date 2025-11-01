return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      auto_install = true,
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "html",
          "cssls",
          "tailwindcss",
          "astro",
          "clangd",
          "bashls",
          "gopls",
          "dockerls",
          "pyright",
          "marksman",
          "rust_analyzer",
          "zls",
          "vimls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")
      local servers = {
        lua_ls = {},
        ts_ls = {},
        cssls = {},
        html = {},
        tailwindcss = { filetypes = { "html", "css", "javascript", "typescript", "tsx" } },
        astro = {},
        clangd = {},
        bashls = {},
        gopls = {},
        dockerls = {},
        pyright = {},
        marksman = {},
        rust_analyzer = {},
        zls = {},
        vimls = {},
      }

      for server, opts in pairs(servers) do
        opts.capabilities = capabilities
        lspconfig[server].setup(opts)
      end
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
