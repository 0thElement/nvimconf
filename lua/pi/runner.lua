local M = {}

local function decode_event(line)
  local ok, decoded = pcall(vim.json.decode, line)
  if not ok then
    return nil
  end
  return decoded
end

local function normalize(event)
  if not event or not event.type then
    return nil
  end

  if event.type == "message_update" then
    local delta = event.assistantMessageEvent
    if delta and delta.type == "text_delta" and type(delta.delta) == "string" then
      return { type = "text", text = delta.delta }
    end
    if delta and delta.type == "thinking_delta" then
      return { type = "thinking" }
    end
    if delta and delta.type == "error" then
      return { type = "error", message = delta.reason or "unknown error" }
    end
    return nil
  end

  if event.type == "message_end" and event.message and event.message.role == "assistant" then
    local text = {}
    for _, block in ipairs(event.message.content or {}) do
      if block.type == "text" and type(block.text) == "string" then
        text[#text + 1] = block.text
      end
    end
    return { type = "assistant_message", text = table.concat(text, '\n') }
  end

  if event.type == "tool_execution_start" then
    return { type = "tool_start", tool = event.toolName or "unknown" }
  end

  if event.type == "tool_execution_end" then
    return { type = "tool_end", tool = event.toolName or "unknown" }
  end

  if event.type == "agent_end" then
    return { type = "done" }
  end

  if event.type == "response" and event.success == false then
    return { type = "error", message = event.error or "unknown error", terminal = event.command == 'prompt' }
  end

  return nil
end

local function feed_stream(session, key, chunk, on_event, on_error)
  if session.cancelled or not chunk or chunk == "" then
    return
  end

  session[key] = (session[key] or "") .. chunk

  while true do
    local newline = session[key]:find("\n", 1, true)
    if not newline then
      break
    end

    local line = session[key]:sub(1, newline - 1)
    session[key] = session[key]:sub(newline + 1)

    if line ~= "" then
      local event = decode_event(line)
      if event then
        local normalized = normalize(event)
        if normalized then
          on_event(normalized)
        end
      elseif on_error then
        on_error(line)
      end
    end
  end
end

-- One transport per Neovim instance. Each prompt has its own UI/log record,
-- while the RPC process retains the conversation between prompts.
local connection
local lost = false

local function dispatch(conn, name, ...)
  if connection ~= conn then return end
  local handlers = conn.handlers
  if handlers and handlers[name] then handlers[name](...) end
end

function M.is_busy()
  return connection ~= nil and connection.handlers ~= nil
end

function M.start(session, cmd, payload, handlers)
  if lost then
    return nil, 'Pi process exited; use :PiNew to start a fresh conversation'
  end
  if M.is_busy() then
    return nil, 'Pi is still finishing the previous request'
  end
  if not connection then
    local conn = { stdout_tail = '', stderr_tail = '' }
    connection = conn
    local function on_event(event)
      if connection ~= conn then return end
      local current = conn.handlers
      -- Release before notifying the consumer, allowing a subsequent prompt.
      if event.type == 'done' or event.terminal then conn.handlers = nil end
      if current then current.on_event(event) end
    end
    local ok, process = pcall(vim.system, cmd, {
      text = true,
      stdin = true,
      stdout = vim.schedule_wrap(function(err, data)
        if connection ~= conn then return end
        if err then dispatch(conn, 'on_error', err); return end
        feed_stream(conn, 'stdout_tail', data, on_event, nil)
      end),
      stderr = vim.schedule_wrap(function(err, data)
        if connection ~= conn then return end
        if err then dispatch(conn, 'on_error', err); return end
        feed_stream(conn, 'stderr_tail', data, function() end, function(line)
          dispatch(conn, 'on_stderr', line)
        end)
      end),
    }, vim.schedule_wrap(function(result)
      if connection ~= conn then return end
      if conn.stdout_tail ~= '' then
        local event = decode_event(conn.stdout_tail)
        local normalized = event and normalize(event)
        if normalized then on_event(normalized) end
      end
      if conn.stderr_tail ~= '' then dispatch(conn, 'on_stderr', conn.stderr_tail) end
      local current = conn.handlers
      connection = nil
      lost = true
      if current then current.on_exit(result) end
      vim.notify('Pi process exited; use :PiNew to start a fresh conversation', vim.log.levels.WARN)
    end))
    if not ok then connection = nil; return nil, process end
    conn.process = process
  end
  local conn = connection
  conn.handlers = handlers
  session.process = conn.process
  local wrote, err = pcall(conn.process.write, conn.process, payload)
  if not wrote then
    connection = nil
    lost = true
    pcall(conn.process.kill, conn.process, 15)
    return nil, err
  end
  return conn.process
end

-- Abort only the current turn; keep the process and its conversation alive.
-- The transport remains busy until agent_end so late output cannot leak into
-- the next prompt's log or notifications.
function M.cancel()
  if connection then
    local ok, err = pcall(connection.process.write, connection.process,
      vim.json.encode({ type = 'abort' }) .. '\n')
    if not ok then
      vim.notify('Pi abort failed: ' .. tostring(err) .. '; use :PiNew', vim.log.levels.ERROR)
    end
  end
end

function M.reset()
  local old = connection
  connection = nil -- Ignore callbacks still queued by the old process.
  lost = false
  if old and old.process then
    pcall(old.process.kill, old.process, 15)
  end
end

return M
