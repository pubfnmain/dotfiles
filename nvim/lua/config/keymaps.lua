local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Diagnostic float' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })

local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
map('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
map('n', '<leader>fw', builtin.grep_string, { desc = 'Grep word under cursor' })
map('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })
map('n', '<leader>fk', builtin.keymaps, { desc = 'Keymaps' })
map('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })
map('n', '<leader><leader>', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Search in buffer' })

map({ 'n', 'v' }, '<leader>cf', '<cmd>Format<CR>', { desc = 'Format buffer/range' })
