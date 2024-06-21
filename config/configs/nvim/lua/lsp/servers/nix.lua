local nix_on_attach = function(client, bufnr)
  require('lsp-format').on_attach(client, bufnr)
  common.on_attach(client, bufnr)
end

require('lspconfig').nixd.setup {
  on_attach = on_attach,
}
