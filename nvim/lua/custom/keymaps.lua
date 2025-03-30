vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move cursor up and center' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move cursor down and center' })

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>', { desc = 'Source current file' })
vim.keymap.set('n', '<space>x', ':.lua<CR>', { desc = 'Source current file' })
vim.keymap.set('v', '<space>x', ':.lua<CR>', { desc = 'Source current file' })

vim.keymap.set('n', '<leader>zz', '<cmd>lua require("zen-mode").toggle({plugins = { twilight = { enabled = false}} })<CR>', { desc = 'Toggle [Z]en mode' })
