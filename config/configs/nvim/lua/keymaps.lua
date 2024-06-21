-- [[ Basic Keymaps ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.keymap.set('n', '<leader>wa', '<cmd>wa!<cr>', { desc = 'Force Write All' })
vim.keymap.set('n', '|', '<cmd>vsplit<cr>', { desc = 'Vertical Split' })
vim.keymap.set('n', '\\', '<cmd>split<cr>', { desc = 'Horizontal Split' })

vim.keymap.set('n', '<leader>n', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Explorer' })
vim.keymap.set('n', '<leader>l', '<cmd>Legendary<cr>', { desc = 'Toggle Legendary Command Runner' })
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { desc = 'Open LSP code actions' })
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })

vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { desc = 'Go Declaration', noremap = true, silent = true })
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Go Defitnition', noremap = true, silent = true })

-- Map Ctrl+Tab to the cycle_windows function
vim.keymap.set('n', '<C-Tab>', cycle_windows, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ddc', '<cmd>DapContinue<CR>', { desc = 'Start or continue a debugging session' })
vim.keymap.set('n', '<leader>ddb', '<cmd>DapToggleBreakpoint<CR>', { desc = 'Toggle breakpoint at line' })
vim.keymap.set('n', '<leader>ddt', '<cmd>DapTerminate<CR>', { desc = 'Terminate a debugging session' })
vim.keymap.set('n', '<leader>ddu', '<cmd>DapToggleUI<CR>', { desc = 'Toggle the DAP UI' })
vim.keymap.set('n', '<F5>', '<cmd>DapContinue<CR>', { desc = 'Start or continue a debugging session' })
vim.keymap.set('n', '<F6>', '<cmd>DapStepOver<CR>', { desc = 'Step over' })
vim.keymap.set('n', '<F7>', '<cmd>DapStepInto<CR>', { desc = 'Step into' })
vim.keymap.set('n', '<F8>', '<cmd>DapStepOut<CR>', { desc = 'Step out' })

-- auto-session keymap
vim.keymap.set('n', '<leader>sp', require('auto-session.session-lens').search_session, {
  noremap = true,
  desc = '[S]earch auto-session [P]rojects',
})
