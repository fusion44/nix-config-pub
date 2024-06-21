vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {},
  -- LSP configuration
  server = {
    on_attach = function(client, bufnr)
      -- https://github.com/mrcjkb/rustaceanvim/issues/28
      local format_sync_grp = vim.api.nvim_create_augroup('RustaceanFormat', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format()
        end,
        group = format_sync_grp,
      })

      if client.server_capabilities.inlayHintProvider then
        local function toggle_inlay()
          local current_setting = vim.lsp.inlay_hint.is_enabled(bufnr)
          vim.lsp.inlay_hint.enable(bufnr, not current_setting)
        end
        vim.keymap.set('n', '<leader>th', toggle_inlay, { desc = '[lsp] toggle inlay hints' })
      end
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {},
    },
  },
  -- DAP configuration
  dap = {},
}
