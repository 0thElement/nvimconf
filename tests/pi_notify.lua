-- nvim --headless -u NONE -i NONE -l tests/pi_notify.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd())
local added, removed, timers = {}, {}, {}
local original_defer, original_notify = vim.defer_fn, vim.notify
_G.MiniNotify = {
  add = function(message, level, _, data)
    added[#added + 1] = { message = message, level = level, data = data }
    return #added
  end,
  remove = function(id) removed[id] = true end,
}
vim.defer_fn = function(callback, duration)
  timers[#timers + 1] = { callback = callback, duration = duration }
end
local ui = require('pi.ui')
local session = { id = 1, responses = { 'First answer', 'Second answer\n```lua\nprint(1)\n```' }, response_chunks = {} }
ui.show_response(session)
ui.show_response(session)
assert(#added == 1, 'duplicate output notification')
assert(added[1].message:find(table.concat(session.responses, '\n\n'), 1, true))
assert(added[1].data.source == 'pi')
assert(timers[1].duration == 15000)
timers[1].callback()
assert(removed[1])
ui.show_response({ responses = {}, response_chunks = {} })
assert(#added == 1, 'empty response notification')
_G.MiniNotify = nil
local fallback
vim.notify = function(message) fallback = message end
ui.show_response({ responses = {}, response_chunks = { 'Hello ', 'world' } })
assert(fallback:find('Hello world', 1, true))
vim.defer_fn, vim.notify = original_defer, original_notify
print('PASS: full response, deduplication, expiry, empty output, fallback')
