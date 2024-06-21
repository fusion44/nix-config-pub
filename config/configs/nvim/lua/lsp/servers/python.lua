-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings

local ruff_python_on_attach = function(client, bufnr)
  require('lsp-format').on_attach(client, bufnr)
  common.on_attach(client, bufnr)
end

require('lspconfig').ruff_lsp.setup {
  on_attach = ruff_python_on_attach,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    },
  },
}

require('lspconfig').pyright.setup {
  -- on_attach = require('lsp-format').on_attach,
}
