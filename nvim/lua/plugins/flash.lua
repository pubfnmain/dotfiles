local flash = require('flash')

flash.setup({
  modes = {
    char = { jump_labels = true },
  },
})

vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter, { desc = 'Flash treesitter' })
vim.keymap.set('o', 'r', flash.remote, { desc = 'Remote flash' })
vim.keymap.set({ 'o', 'x' }, 'R', flash.treesitter_search, { desc = 'Flash treesitter search' })
vim.keymap.set('c', '<C-s>', flash.toggle, { desc = 'Toggle flash search' })
