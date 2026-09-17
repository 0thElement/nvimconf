-- Run from the config directory: nvim --headless -u NONE -i NONE -l tests/pi_smoke.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd())
for _, path in ipairs(vim.fn.glob('lua/pi/*.lua', false, true)) do
  assert(loadfile(path))
end
dofile('plugin/pi.nvim.lua')
for _, command in ipairs({ 'PiAsk', 'PiAskSelection', 'PiCancel', 'PiLog', 'PiNew' }) do
  assert(vim.fn.exists(':' .. command) == 2, command .. ' missing')
end
local pi = require('pi')
pi.setup({})
assert(pi.get_cmd()[1] == 'pi')
local log = require('pi.log')
assert(log.DEFAULT_PATH == vim.fn.stdpath('log') .. '/pi-nvim.log')
local original_path = log.DEFAULT_PATH
local test_dir = vim.fn.tempname()
log.DEFAULT_PATH = test_dir .. '/nested/pi.log'
log.append_session(nil, { history = { 'local smoke test' } }, 'test', 'done', nil)
assert(vim.fn.filereadable(log.DEFAULT_PATH) == 1)
local initial_windows = #vim.api.nvim_tabpage_list_wins(0)
vim.g.phone_mode = false
vim.cmd('PiLog')
assert(#vim.api.nvim_tabpage_list_wins(0) == initial_windows + 1)
assert(vim.wo.wrap and vim.wo.linebreak)
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'):find('local smoke test', 1, true))
vim.fn.maparg('q', 'n', false, true).callback()
assert(#vim.api.nvim_tabpage_list_wins(0) == initial_windows)
vim.g.phone_mode = true
local previous = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(previous, 0, -1, false, { 'unsaved edits' })
vim.cmd('PiLog')
assert(#vim.api.nvim_tabpage_list_wins(0) == initial_windows)
assert(vim.wo.wrap and vim.wo.linebreak)
vim.fn.maparg('q', 'n', false, true).callback()
assert(vim.api.nvim_get_current_buf() == previous)
assert(vim.bo.modified and vim.api.nvim_buf_get_lines(previous, 0, 1, false)[1] == 'unsaved edits')
vim.fn.delete(log.DEFAULT_PATH)
vim.fn.delete(test_dir .. '/nested', 'd')
vim.fn.delete(test_dir, 'd')
log.DEFAULT_PATH = original_path

-- Opening a directory as a file must report an error, not fail silently.
local notify = vim.notify
local warning
vim.notify = function(message, level)
  warning = { message = message, level = level }
end
log.append_session(vim.fn.getcwd(), { history = {} }, 'test', 'error', nil)
vim.notify = notify
assert(warning and warning.level == vim.log.levels.WARN)
assert(warning.message:find('Failed to write pi log', 1, true))
print('PASS: vendored modules, commands, log creation/display, write error reporting')
