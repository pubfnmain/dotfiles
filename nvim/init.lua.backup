vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.laststatus = 0
vim.opt.guicursor = "i-ci:block-blinkwait200-blinkoff200-blinkon200"


require('config.options')
require('config.plugins')
require('config.keymaps')
require('config.lsp')


vim.o.showtabline = 2

function _G.BufTabline()
  local s = ""
  local cur = vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted then
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":t")
      if name == "" then name = "[No Name]" end
      name = name:gsub("%%", "%%%%") -- escape % for statusline syntax
      local hl = (b == cur) and "%#TabLineSel#" or "%#TabLine#"
      s = s .. hl .. " " .. name .. " "
    end
  end
  return s .. "%#TabLineFill#"
end

vim.o.tabline = "%!v:lua.BufTabline()"
