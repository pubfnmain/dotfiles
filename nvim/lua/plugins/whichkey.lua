local wk = require('which-key')

wk.setup({
  preset = 'modern',
})

wk.add({
  { '<leader>f', group = 'Find (telescope)' },
  { '<leader>h', group = 'Git hunks' },
  { '<leader>ht', group = 'Git toggles' },
  { '<leader>l', group = 'LSP' },
  { '<leader>c', group = 'Code' },
})
