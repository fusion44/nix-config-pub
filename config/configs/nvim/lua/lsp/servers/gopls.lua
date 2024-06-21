local go_on_attach = function(client, bufnr)
  require('lsp-format').on_attach(client, bufnr)
  common.on_attach(client, bufnr)
end

require('lspconfig').gopls.setup {
  on_attach = go_on_attach,
}
