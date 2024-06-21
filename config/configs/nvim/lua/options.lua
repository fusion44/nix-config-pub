-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- minimum number of lines to keep above and
-- below the cursor
vim.o.scrolloff = 8

-- highlight the current line
vim.o.cursorline = true

-- wrap lines when longer than screen width
vim.o.wrap = true
vim.o.tabstop = 3
vim.o.shiftwidth = 3

-- automatically reload buffers when file contents
-- are changed from an external tool
-- https://unix.stackexchange.com/a/383044
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { '*' },
})

-- Ask if any unsaved buffers should be saved
-- when exiting vim.
vim.o.cf = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.o.nu = true
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- https://johncodes.com/posts/2023/02-25-nvim-spell/
-- Usage:
-- z= - open list of suggestions
-- ]s - will go to the next misspelled word.
-- [s - will go to the previous misspelled word.
-- zg - will add hovered word to spellbook
vim.o.spelllang = 'en_us'
vim.o.spell = true
