local ok, notify = pcall(require, 'mini.notify')
if not ok then
  return -- First startup before :PlugInstall.
end

notify.setup({
  lsp_progress = { enable = false },
  window = {
    max_width_share = vim.g.phone_mode and 0.95 or 0.5,
    winblend = 0,
  },
})
vim.notify = notify.make_notify()
