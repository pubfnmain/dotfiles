local filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
}

local function vue_typescript_plugin()
  if vim.fn.executable('vue-language-server') ~= 1 then
    return nil
  end
  local bin = vim.fn.exepath('vue-language-server')
  local dir = vim.fn.resolve(bin):match('(.*/@vue/language%-server)/')
  if not (dir and vim.fn.isdirectory(dir) == 1) then
    local root = vim.fn.trim(vim.fn.system({ 'npm', 'root', '-g' }))
    dir = root .. '/@vue/language-server'
    if vim.fn.isdirectory(dir) ~= 1 then
      return nil
    end
  end
  return {
    name = '@vue/typescript-plugin',
    location = dir,
    languages = { 'vue' },
    configNamespace = 'typescript',
  }
end

local global_plugins = {}
local vue_plugin = vue_typescript_plugin()
if vue_plugin then
  table.insert(global_plugins, vue_plugin)
  table.insert(filetypes, 'vue')
end

return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = filetypes,
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = global_plugins,
      },
    },
    typescript = {
      inlayHints = {
        parameterNames = { enabled = 'literals' },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
      },
    },
  },
}
