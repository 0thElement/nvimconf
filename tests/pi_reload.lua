-- nvim --headless -u NONE -i NONE -l tests/pi_reload.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd())
package.loaded['pi.ui'] = {
  open = function() end, close = function() end, update = function() end,
  show_response = function() end,
}
local pi = require('pi')
local log = require('pi.log')
local original_log, original_system, original_notify = log.DEFAULT_PATH, vim.system, vim.notify
local file, log_file = vim.fn.tempname(), vim.fn.tempname()
log.DEFAULT_PATH = log_file
local warnings, stdout = {}, nil
vim.notify = function(message) warnings[#warnings + 1] = message end
vim.system = function(_, opts)
  stdout = opts.stdout
  return { write = function() end, kill = function() end }
end
vim.fn.writefile({ 'one', 'two', 'three' }, file)
vim.cmd('edit ' .. vim.fn.fnameescape(file))
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_win_set_cursor(0, { 2, 1 })
local function emit(kind)
  stdout(nil, vim.json.encode({ type = kind, toolName = 'edit' }) .. '\n')
  vim.wait(20, function() return false end)
end
local function ask(skip)
  pi.run({ message = 'edit', build_context = function() return '' end, skip_reload = skip })
end
ask()
vim.fn.writefile({ 'one changed', 'two', 'three' }, file)
emit('tool_execution_end')
assert(pi.is_running(), 'must refresh before agent_end')
assert(vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == 'one changed')
assert(vim.deep_equal(vim.api.nvim_win_get_cursor(0), { 2, 1 }))
local tick = vim.api.nvim_buf_get_changedtick(bufnr)
emit('tool_execution_end')
assert(vim.api.nvim_buf_get_changedtick(bufnr) == tick, 'unchanged file reloaded')
vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { 'my unsaved edit' })
vim.fn.writefile({ 'agent changed it again', 'two', 'three' }, file)
emit('tool_execution_end')
emit('tool_execution_end')
emit('agent_end')
assert(vim.bo[bufnr].modified)
assert(vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == 'my unsaved edit')
assert(#warnings == 1 and warnings[1]:find('unsaved edits', 1, true))
vim.cmd('edit!') -- Explicitly discard this test's local edit.
ask(true)
vim.fn.writefile({ 'skip reload should leave previous buffer text' }, file)
emit('tool_execution_end')
emit('agent_end')
assert(vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == 'agent changed it again')
pi.shutdown()
vim.api.nvim_buf_delete(bufnr, { force = true })
vim.fn.delete(file)
vim.fn.delete(log_file)
log.DEFAULT_PATH, vim.system, vim.notify = original_log, original_system, original_notify
print('PASS: refresh before completion, cursor retention, no repeat reload, unsaved edit protection, skip_reload')
