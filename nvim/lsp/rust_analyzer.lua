return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
        buildScripts = { enable = true },
      },
      check = {
        command = 'clippy',
      },
      procMacro = {
        enable = true,
      },
      inlayHints = {
        bindingModeHints = { enable = false },
        closureReturnTypeHints = { enable = 'always' },
        parameterHints = { enable = true },
        typeHints = { enable = true },
      },
    },
  },
}
