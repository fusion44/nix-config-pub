local nt = require 'neotest'

nt.setup {
  adapters = {
    require 'rustaceanvim.neotest',
  },
}

local function run_dap_wrapper()
  nt.run.run { strategy = 'dap' }
end

local function run_all_wrapper()
  nt.run.run(vim.fn.expand '%')
end

local function open_output_modal()
  nt.output.open { enter = true }
end

vim.keymap.set('n', '<leader>mn', nt.run.run, { desc = '[neotest] run the narest test' })
vim.keymap.set('n', '<leader>md', run_dap_wrapper, { desc = '[neotest] debug the nearest test' })
vim.keymap.set('n', '<leader>mr', run_all_wrapper, { desc = '[neotest] run all tests in current buffer' })
vim.keymap.set('n', '<leader>ms', nt.run.stop, { desc = '[neotest] stop the nearest test' })
vim.keymap.set('n', '<leader>ma', nt.run.attach, { desc = '[neotest] attach to the nearest test' })
vim.keymap.set('n', '<leader>ml', nt.run.run_last, { desc = '[neotest] run the last test with same args' })
vim.keymap.set('n', '<leader>mo', nt.output.open, { desc = '[neotest] open output window enter closes' })
vim.keymap.set('n', '<leader>mO', open_output_modal, { desc = '[neotest] open output window modal' })
vim.keymap.set('n', '<leader>mu', nt.summary.toggle, { desc = '[neotest] open summary window' })
