vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.laststatus = 0
vim.opt.guicursor = "i-ci:block-blinkwait200-blinkoff200-blinkon200"


require('config.options')
require('config.plugins')
require('config.keymaps')
require('config.lsp')
