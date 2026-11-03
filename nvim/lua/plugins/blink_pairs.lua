pcall(function()
  require('blink.pairs').download():pwait(60000)
end)

require('blink.pairs').setup({
  mappings = { enabled = true },
  highlights = { enabled = true },
})
