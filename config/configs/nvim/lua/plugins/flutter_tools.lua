require('flutter-tools').setup {
  -- https://github.com/akinsho/flutter-tools.nvim/issues/178
  settings = {
    lineLength = (function()
      return vim.fn.expand('%:p'):find '^/home/f44/dev/stuff/jaspr/' and 120 or 80
    end)(),
  },
  debugger = {
    enabled = true,
    run_via_dap = true,
    register_configurations = function(_)
      require('dap').configurations.dart = {}
      require('dap.ext.vscode').load_launchjs()
    end,
  },
  lsp = {
    on_attach = require('lsp-format').on_attach,
  },
}
