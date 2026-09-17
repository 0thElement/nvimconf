-- nvim --headless -u NONE -i NONE -l tests/pi_persistent.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd())
package.loaded['pi.ui'] = {
  open = function() end, close = function() end, update = function() end,
  show_response = function() end,
}
local pi = require('pi')
local runner = require('pi.runner')
local log = require('pi.log')
local original_system, original_notify = vim.system, vim.notify
local original_path = log.DEFAULT_PATH
log.DEFAULT_PATH = vim.fn.tempname()
vim.notify = function() end
local processes = {}
vim.system = function(_, opts, callback)
  local proc = { writes = {}, stdout = opts.stdout, exit = callback }
  function proc:write(data)
    assert(data ~= nil, 'stdin must stay open between requests')
    self.writes[#self.writes + 1] = vim.json.decode(data)
  end
  function proc:kill() self.killed = true end
  processes[#processes + 1] = proc
  return proc
end
local function emit(proc, event)
  proc.stdout(nil, vim.json.encode(event) .. '\n')
  vim.wait(10, function() return false end)
end
local function ask(text)
  pi.run({ message = text, build_context = function() return 'fresh buffer context' end, skip_reload = true })
end
ask('first')
local first = processes[1]
ask('busy request')
assert(#first.writes == 1)
emit(first, { type = 'agent_end' })
ask('follow-up')
assert(#processes == 1 and #first.writes == 2, 'follow-up spawned a new process')
assert(first.writes[2].message:find('follow-up', 1, true))
pi.cancel()
assert(first.writes[3].type == 'abort' and not first.killed)
ask('too early after abort')
assert(#first.writes == 3)
emit(first, { type = 'agent_end' })
ask('after abort')
assert(#processes == 1 and #first.writes == 4)
pi.new_session() -- Also works during an active request.
assert(first.killed and not runner.is_busy())
ask('new conversation')
assert(#processes == 2)
local second = processes[2]
emit(first, { type = 'agent_end' })
first.exit({ code = 0, signal = 15 })
vim.wait(10, function() return false end)
assert(pi.is_running(), 'old process callback ended the new request')
emit(second, { type = 'agent_end' })
second.exit({ code = 1, signal = 0 }) -- Idle process death must not silently lose history.
vim.wait(10, function() return false end)
ask('after crash')
assert(#processes == 2)
assert(pi._get_last_session().last_error:find(':PiNew', 1, true))
pi.new_session()
ask('recover')
assert(#processes == 3)
pi.shutdown()
assert(processes[3].killed and not runner.is_busy())
vim.fn.delete(log.DEFAULT_PATH)
log.DEFAULT_PATH = original_path
vim.system, vim.notify = original_system, original_notify
print('PASS: process reuse, busy guard, abort reuse, reset, stale events, crash recovery, shutdown')
