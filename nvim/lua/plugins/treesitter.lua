local ts = require('nvim-treesitter')

ts.setup({
  install_dir = vim.fn.stdpath('data') .. '/site',
})

local ensure = {
  'python',
  'go',
  'gomod',
  'gosum',
  'rust',
  'c',
  'lua',
  'vim',
  'vimdoc',
  'query',
  'markdown',
  'markdown_inline',
  'bash',
  'json',
  'yaml',
  'toml',
  'html',
  'css',
  'javascript',
  'typescript',
  'tsx',
  'vue',
}
ts.install(ensure)

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ts-highlight', { clear = true }),
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end
    local ok, added = pcall(vim.treesitter.language.add, lang)
    if not ok or not added then
      return
    end
    vim.treesitter.start(args.buf, lang)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})

vim.opt.foldmethod = 'expr'
vim.opt.foldlevelstart = 99
