-- pi.nvim - Neovim plugin for pi coding agent
-- Maintainer: pablopunk
-- License: MIT

-- Prevent the plugin from being loaded more than once.
if vim.g.loaded_pi_nvim then
  return
end
vim.g.loaded_pi_nvim = true

-- Register user-facing commands exposed by the plugin.

-- Open a prompt using the current buffer as additional context.
vim.api.nvim_create_user_command("PiAsk", function()
  require("pi").prompt_with_buffer()
end, { desc = "Ask pi with current buffer as context" })

-- Open a prompt using the current visual selection as context.
vim.api.nvim_create_user_command("PiAskSelection", function(opts)
  require("pi").prompt_with_selection(opts)
end, { range = true, desc = "Ask pi with visual selection as context" })

-- Cancel the currently running pi request, if there is one.
vim.api.nvim_create_user_command("PiCancel", function()
  require("pi").cancel()
end, { desc = "Cancel the active pi request" })

-- Show the pi.nvim session log
vim.api.nvim_create_user_command('PiNew', function()
  require('pi').new_session()
end, { desc = 'Reset Pi conversation; next PiAsk starts a fresh session' })

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = vim.api.nvim_create_augroup('PiShutdown', { clear = true }),
  callback = function()
    if package.loaded.pi then require('pi').shutdown() end
  end,
})

vim.api.nvim_create_user_command("PiLog", function()
  require("pi").show_log()
end, { desc = "Show pi session log" })
