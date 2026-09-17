local M = {}

M.DEFAULT_PATH = vim.fn.stdpath('log') .. '/pi-nvim.log'

local function format_time()
  return os.date("%Y-%m-%d %H:%M:%S")
end

function M.append_session(log_path, session, message, status, source_path)
  log_path = log_path or M.DEFAULT_PATH

  local lines = {
    "",
    "=" .. string.rep("=", 78),
    string.format("[%s] %s", format_time(), status:upper()),
    "=" .. string.rep("=", 78),
    "Prompt: " .. (message or "(empty)"),
    "File: " .. (source_path or "(no file)"),
    "Status: " .. status,
  }

  if session.last_error then
    table.insert(lines, "Error: " .. session.last_error)
  end

  local responses = vim.list_extend({}, session.responses or {})
  local partial = table.concat(session.response_chunks or {})
  if partial ~= '' then
    responses[#responses + 1] = partial
  end
  if #responses > 0 then
    table.insert(lines, '')
    table.insert(lines, '--- Agent Output ---')
    table.insert(lines, table.concat(responses, '\n\n'))
  end

  if #session.history > 0 then
    table.insert(lines, "")
    table.insert(lines, "--- Session History ---")
    for _, entry in ipairs(session.history) do
      table.insert(lines, entry)
    end
  end

  local ok, err = pcall(function()
    vim.fn.mkdir(vim.fn.fnamemodify(log_path, ':h'), 'p')
    local file, open_err = io.open(log_path, "a")
    if not file then
      error(open_err)
    end
    local wrote, write_err = file:write(table.concat(lines, '\n') .. '\n')
    local closed, close_err = file:close()
    if not wrote then error(write_err) end
    if not closed then error(close_err) end
  end)

  if not ok then
    vim.notify("Failed to write pi log: " .. tostring(err), vim.log.levels.WARN)
  end
end

return M
