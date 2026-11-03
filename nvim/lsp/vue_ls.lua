return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json' },
  on_init = function(client)
    client.handlers['tsserver/request'] = function(_, result, context)
      local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
      if #ts_clients == 0 then
        vim.notify(
          'vue_ls: no `vtsls` client attached; TypeScript features in .vue files will not work.',
          vim.log.levels.ERROR
        )
        return
      end
      local ts_client = ts_clients[1]

      local id, command, payload = unpack(result[1])
      ts_client:exec_cmd({
        title = 'vue_ts_request_forward',
        command = 'typescript.tsserverRequest',
        arguments = { command, payload },
      }, { bufnr = context.bufnr }, function(_, r)
        client:notify('tsserver/response', { { id, r and r.body } })
      end)
    end
  end,
}
