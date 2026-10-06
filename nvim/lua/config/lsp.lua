vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

local servers = {
  pyright = 'pyright-langserver',
  ruff = 'ruff',
  gopls = 'gopls',
  rust_analyzer = 'rust-analyzer',
  clangd = 'clangd',
  vtsls = 'vtsls',
  vue_ls = 'vue-language-server',
  html = 'vscode-html-language-server',
  cssls = 'vscode-css-language-server',
  sqls = 'sqls',
}

for server, cmd in pairs(servers) do
  if vim.fn.executable(cmd) == 1 then
    vim.lsp.enable(server)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    local tb = require('telescope.builtin')
    map('n', 'grd', tb.lsp_definitions, 'Goto definition')
    map('n', 'grD', vim.lsp.buf.declaration, 'Goto declaration')
    map('n', 'gri', tb.lsp_implementations, 'Goto implementation')
    map('n', 'grt', tb.lsp_type_definitions, 'Goto type definition')
    map('n', 'grr', tb.lsp_references, 'References')

    map('n', 'grn', vim.lsp.buf.rename, 'Rename')
    map({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, 'Code action')
    map('n', 'K', vim.lsp.buf.hover, 'Hover')
    map('i', '<C-s>', vim.lsp.buf.signature_help, 'Signature help')
    map('n', '<leader>ls', tb.lsp_document_symbols, 'Document symbols')
    map('n', '<leader>lw', tb.lsp_dynamic_workspace_symbols, 'Workspace symbols')

    if client and client:supports_method('textDocument/inlayHint') then
      map('n', '<leader>lh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, 'Toggle inlay hints')
    end

    if client and client:supports_method('textDocument/documentHighlight') then
      local hl_group = vim.api.nvim_create_augroup('lsp-highlight-' .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
