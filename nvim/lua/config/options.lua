local o = vim.opt

o.number = true
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true
o.termguicolors = true
o.scrolloff = 8
o.splitright = true
o.splitbelow = true
o.wrap = false
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true

o.ignorecase = true
o.smartcase = true

o.completeopt = { 'menuone', 'noselect', 'fuzzy', 'popup' }
o.pumheight = 12

o.swapfile = false
o.undofile = true
o.updatetime = 250
o.timeoutlen = 400

o.mouse = 'a'
o.clipboard = 'unnamedplus'
o.confirm = true

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
})
