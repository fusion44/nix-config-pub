local null_ls = require 'null-ls'

local nonels_on_attach = function(client, bufnr)
  require('lsp-format').on_attach(client, bufnr)
  common.on_attach(client, bufnr)
end

null_ls.setup {
  on_attach = on_attach,
  sources = {
    null_ls.builtins.formatting.alejandra,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.golines,
  },
}
