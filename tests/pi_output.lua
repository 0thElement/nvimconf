-- nvim --headless -u NONE -i NONE -l tests/pi_output.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd())
local response_notifications = 0
package.loaded['pi.ui'] = {
  open = function() end, update = function() end, close = function() end,
  show_response = function() response_notifications = response_notifications + 1 end,
}
local pi = require('pi')
local log = require('pi.log')
local original_system = vim.system
local original_path = log.DEFAULT_PATH
local path = vim.fn.tempname()
log.DEFAULT_PATH = path
local stdout, on_exit
vim.system = function(_, opts, callback)
  stdout, on_exit = opts.stdout, callback
  return { write = function() end, kill = function() end, is_closing = function() return false end }
end
local function send(event)
  local encoded = vim.json.encode(event) .. '\n'
  -- Exercise JSON lines split across process output chunks.
  stdout(nil, encoded:sub(1, 8))
  stdout(nil, encoded:sub(9))
  vim.wait(20, function() return false end)
end
local function start()
  pi.run({ message = 'test', build_context = function() return '' end, skip_reload = true })
end
local function delta(text)
  send({ type = 'message_update', assistantMessageEvent = { type = 'text_delta', delta = text } })
end
local function finish_message(text)
  send({ type = 'message_end', message = { role = 'assistant', content = {
    { type = 'thinking', thinking = 'PRIVATE_THINKING' },
    { type = 'text', text = text },
  } } })
end
local function contents()
  return table.concat(vim.fn.readfile(path), '\n')
end
start()
delta('First ')
delta('answer\n```lua\nprint(1)\n```')
finish_message('First answer\n```lua\nprint(1)\n```')
send({ type = 'message_end', message = { role = 'toolResult', content = { { type = 'text', text = 'TOOL_RESULT' } } } })
finish_message('Second answer') -- Final message without deltas must also work.
send({ type = 'agent_end' })
assert(response_notifications == 1)
local text = contents()
assert(text:find('--- Agent Output ---', 1, true))
assert(text:find('First answer\n```lua\nprint(1)\n```\n\nSecond answer', 1, true))
local _, count = text:gsub('First answer', '')
assert(count == 1, 'response duplicated')
assert(not text:find('PRIVATE_THINKING', 1, true))
assert(not text:find('TOOL_RESULT', 1, true))
start()
delta('Partial before error')
send({ type = 'response', command = 'prompt', success = false, error = 'simulated failure' })
assert(contents():find('Partial before error', 1, true))
assert(contents():find('simulated failure', 1, true))
start()
delta('Partial before cancel')
pi.cancel()
assert(contents():find('Partial before cancel', 1, true))
send({ type = 'agent_end' }) -- Abort completes before accepting the next prompt.
start()
-- Last JSON event without a newline must be drained on process exit.
stdout(nil, vim.json.encode({ type = 'message_update', assistantMessageEvent = { type = 'text_delta', delta = 'Partial before exit' } }))
on_exit({ code = 1, signal = 0 })
vim.wait(20, function() return false end)
assert(contents():find('Partial before exit', 1, true))
pi.show_log()
assert(response_notifications == 1, 'failed or cancelled sessions must not notify success')
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'):find('Second answer', 1, true))
vim.system = original_system
log.DEFAULT_PATH = original_path
vim.fn.delete(path)
print('PASS: streamed/final output, multiple messages, no duplicates, partial failure/cancel/exit, PiLog display')
