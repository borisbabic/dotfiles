return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "markdownlint",
        "prettier",
        "shellcheck",
        "sql-formatter",
        -- "lua-language-server",
        "qmlls",
        "json-lsp",
        -- "nixd",
        -- "tailwindcss",
        "expert"
      },
    },
  },

}
