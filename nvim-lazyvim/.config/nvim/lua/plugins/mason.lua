return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "markdownlint",
        "prettier",
        "shellcheck",
        "sql-formatter",
        "lua-language-server",
        "json-lsp",
        "stylua",
      },
    },
  },

}
