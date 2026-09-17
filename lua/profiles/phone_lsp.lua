-- Install these server executables on the SSH host, not the Android client.
-- Only available servers are enabled. Add other lspconfig server names here.
local servers = {
  nil_ls = { command = 'nil', settings = {} },
  rust_analyzer = { command = 'rust-analyzer', settings = {} },
}

for name, server in pairs(servers) do
  if vim.fn.executable(server.command) == 1 then
    local opts = { settings = server.settings }
    if vim.lsp.config and vim.lsp.enable then
      vim.lsp.config(name, opts)
      vim.lsp.enable(name)
    else
      require('lspconfig')[name].setup(opts)
    end
  end
end
