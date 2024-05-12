-- COPIED FROM https://github.com/lexical-lsp/lexical/blob/main/pages/installation.md

  -- local lspconfig = require("lspconfig")
  -- local configs = require("lspconfig.configs")
  --
--
  local lspconfig = require("lspconfig")
  local configs = require("lspconfig.configs")
  local lexical_config = {
    filetypes = { "elixir", "eelixir", },
    cmd = { "/home/boris/projects/lexical/_build/dev/rel/lexical/start_lexical.sh" },
    settings = {},
  }
  --
  -- if not configs.lexical then
  --   configs.lexical = {
  --     default_config = {
  --       filetypes = lexical_config.filetypes,
  --       cmd = lexical_config.cmd,
  --       root_dir = function(fname)
  --         return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
  --       end,
  --       -- optional settings
  --       settings = lexical_config.settings,
  --     },
  --   }
  -- end
  --
  -- lspconfig.lexical.setup({})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lexical = {
          mason = false,
        }
      },
      setup = {
        lexical = function(_, opts)
          if not configs.lexical then
            configs.lexical = {
              default_config = {
                filetypes = lexical_config.filetypes,
                cmd = lexical_config.cmd,
                root_dir = function(fname)
                  return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
                end,
                settings = lexical_config.settings,
              }
            }
          end
          lspconfig.lexical.setup({})
        end,
      },
    },
  },
}
