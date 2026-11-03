local telescope = require('telescope')

telescope.setup({
  defaults = {
    path_display = { 'truncate' },
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<Esc>'] = require('telescope.actions').close,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = vim.fn.executable('rg') == 1
          and { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' }
        or nil,
    },
  },
})
