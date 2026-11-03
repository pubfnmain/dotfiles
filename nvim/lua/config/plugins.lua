vim.pack.add({
  { src = 'https://github.com/mellow-theme/mellow.nvim' },

  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  { src = 'https://github.com/windwp/nvim-ts-autotag' },

  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },

  { src = 'https://github.com/stevearc/conform.nvim' },

  { src = 'https://github.com/lewis6991/gitsigns.nvim' },

  { src = 'https://github.com/folke/which-key.nvim' },


  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1') },

  { src = 'https://github.com/saghen/blink.lib' },
  { src = 'https://github.com/saghen/blink.pairs', version = vim.version.range('*') },
  { src = 'https://github.com/saghen/blink.indent' },

  { src = 'https://github.com/folke/flash.nvim' },
})

require('plugins.treesitter')
require('plugins.autotag')
require('plugins.conform')
require('plugins.telescope')
require('plugins.gitsigns')
require('plugins.whichkey')
require('plugins.blink_cmp')
require('plugins.blink_pairs')
require('plugins.blink_indent')
require('plugins.flash')

vim.cmd.colorscheme('mellow')
