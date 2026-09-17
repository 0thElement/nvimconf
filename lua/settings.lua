vim.loader.enable()

local o = vim.opt
local g = vim.g

-- Autocmds
vim.cmd [[
augroup CursorLine au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

autocmd FileType nix setlocal shiftwidth=2
]]

-- KEYBINDS --
local map = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }
g.mapleader = ' '

-- Command palette registry.
-- Keymaps set through bind() are mapped as normal *and* added as an entry
-- in the command palette (<C-S-p>), replayed by feeding the same keys.
local keymap_registry = {}

local function replay_keys(lhs)
  return function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(lhs, true, false, true), 'm', false)
  end
end

local function bind(mode, lhs, rhs, name, kopts)
  kopts = vim.tbl_extend('force', {}, opts, kopts or {})
  vim.keymap.set(mode, lhs, rhs, kopts)
  if name then
    table.insert(keymap_registry, {
      name = name,
      lhs = lhs,
      modes = type(mode) == 'table' and mode or { mode },
      action = replay_keys(lhs),
    })
  end
end

-- Navigation
bind('n', '<C-i>', '<cmd>PiAsk<cr>', 'Pi: Ask')
bind('n', '<C-S-i>', '<cmd>PiLog<cr>', 'Pi: Session log')
bind('n', '<C-j>', '<cmd>PiNew<cr>', 'Pi: New session')

bind('n', '-', '<CMD>Oil --float<CR>', 'Files: Open Oil')
bind('n', '@', '<CMD>Telescope resume<CR>', 'Grep: Live Grep')
bind('n', '<C-n>', '<CMD>Telescope live_grep <CR>', 'Grep: Live Grep')
bind('n', '<C-f>', '<CMD>Telescope find_files <CR>', 'Grep: Find Files')
bind('n', '<c-m>', "<cmd>lua require('telescope.builtin').diagnostics({severity = 'error', bufnr=nil})<CR>", 'Diagnostics: Errors Only')
bind('n', '<c-M>', "<cmd>lua require('telescope.builtin').diagnostics({bufnr=nil})<CR>", 'Diagnostics: All')

map('n', '<S-Backspace>', '<C-i>', opts)
map('n', '<Backspace>', '<C-o>', opts)

-- Yanking & registers
for _, m in ipairs({'n', 'v'}) do
    map(m, '<C-y>', '<CMD>let @"=@0<CR>', opts) --Restore backup register
    map(m, '<C-p>', '"0p', opts) --Paste from backup
end

-- Terminal
bind('n', '<C-\\>', '<CMD>FloatermToggle<CR>', 'Terminal: Toggle Terminal')
map('t', '<C-\\>', '<CMD>FloatermToggle<CR>', opts)
map('t', '<C-]>', '<CMD>FloatermNext<CR>', opts)
map('t', '<C-[>', '<CMD>FloatermPrev<CR>', opts)
map('t', '<C-S-[>', '<CMD>FloatermKill<CR><CMD>silent FloatermShow<CR>', opts)
map('t', "<C-S-]>", '<CMD>FloatermNew<CR>', opts)

-- Save
bind('n', '<C-s>', '<CMD>silent lua vim.lsp.buf.format()<CR>:w<cr>', 'Files: Format & Save')

-- Undo breakpoints in insert mode
undobreaks = {
	';',
	',',
	'.',
	'!',
	'?',
	'<CR>',
}
for _, c in ipairs(undobreaks) do
	map('i', c, c..'<c-g>u', opts)
end

-- Keep cursor centered
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)
map('n', 'j', 'jzz', opts)
map('n', 'k', 'kzz', opts)
map('n', 'G', 'Gzz', opts)

-- Insert line
map('n', '<CR>', 'mzo<Esc>`z', opts)
map('n', '<C-CR>', 'i<CR><Esc>k$', opts)
map('n', 'J', 'mzJ`z', opts)

-- Tab
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Harpoon
local harpoon = require('harpoon')
bind('n', '=', function() harpoon:list():add() end, 'Harpoon: Add File')

for n = 1, 9 do
    bind('n', '<c-'..n..'>', function() require('harpoon'):list():select(n) end, 'Harpoon: Select '..n)
end

local border = {
  {"╭", "FloatBorder"},
  {"─", "FloatBorder"},
  {"╮", "FloatBorder"},
  {"│", "FloatBorder"},
  {"╯", "FloatBorder"},
  {"─", "FloatBorder"},
  {"╰", "FloatBorder"},
  {"│", "FloatBorder"},
}
bind('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list(), {
    border = border,
    title = {{" Harpoon ", "FloatBorder"}},
    title_pos = "center",
}) end, 'Harpoon: Toggle Menu')

bind('n', '<F2>', '<cmd>lua require("renamer").rename()<cr>', 'Rename Symbol')

-- Commenting
map('n', '<C-/>', ':Commentary<CR>', opts)
map('v', '<C-/>', ":'<,'>Commentary<CR>", opts)

-- Others
require('nvim-autopairs').setup()
bind({'v', 'n'}, '<C-.>', require("actions-preview").code_actions, 'LSP: Code Actions Preview')
bind('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', 'LSP: Go to Declaration')
bind('n', 'gd', "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", 'LSP: Go to Definition')
bind('n', 'gt', "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", 'LSP: Go to Type Definition')
bind('n', 'gr', "<cmd>lua require('telescope.builtin').lsp_references()<CR>", 'LSP: Go to References')
bind('n', 'L', '<cmd>lua vim.diagnostic.open_float()<CR>', 'LSP: Open Diagnostic Float')
bind('n', 'S', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'LSP: Signature Help')
vim.keymap.del('n','<c-W>d')
bind('n', 'K', vim.lsp.buf.hover, 'LSP: Hover')
bind('n', '[d', '<cmd>lua vim.diagnostic.goto_next()<cr>', 'LSP: Next Diagnostic')
bind('n', ']d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'LSP: Previous Diagnostic')

bind('n', '<C-S-Bslash>', function() vim.cmd('vsplit') end , 'Buffers: Split Vertical')
bind('n', '<C-_>', function() vim.cmd('split') end , 'Buffers: Split Horizontal')
bind('n', '<C-Tab>', '<C-w>w' , 'Buffers: Toggle')
bind('n', '<C-S-Tab>', '<C-w>p' , 'Buffers: Previous')


-- Command palette
-- Curated palette entries, for the things that are not set up through bind():
-- plugin mappings, plugin commands, and built-in keys that are useful but easy
-- to forget. One of these fields per entry:
--   cmd     = run this Ex command
--   prompt  = prefill the cmdline with this Ex command (it wants arguments)
--   keys    = feed these keys from normal mode, complete as-is
--   pending = feed `keys` as a prefix and wait for the rest to be typed
--   run     = call this function
-- `visual = true` reselects the last visual selection (gv) before feeding keys.
local curated = {
  -- Rust (rustaceanvim)
  { name = 'Rust: Code Action', cmd = 'RustLsp codeAction' },
  { name = 'Rust: Hover Actions', cmd = 'RustLsp hover actions' },
  { name = 'Rust: Expand Macro', cmd = 'RustLsp expandMacro' },
  { name = 'Rust: Runnables', cmd = 'RustLsp runnables' },
  { name = 'Rust: Testables', cmd = 'RustLsp testables' },
  { name = 'Rust: Debuggables', cmd = 'RustLsp debuggables' },
  { name = 'Rust: Explain Error', cmd = 'RustLsp explainError' },
  { name = 'Rust: Related Diagnostics', cmd = 'RustLsp relatedDiagnostics' },
  { name = 'Rust: Render Diagnostic', cmd = 'RustLsp renderDiagnostic' },

  -- vim-surround
  { name = 'Surround: Add Around Motion', keys = 'ys', pending = true },
  { name = 'Surround: Add Around Line', keys = 'yss', pending = true },
  { name = 'Surround: Add Around Line, On Own Lines', keys = 'ySS', pending = true },
  { name = 'Surround: Add Around Selection', keys = 'S', visual = true, pending = true },
  { name = 'Surround: Change Surrounding', keys = 'cs', pending = true },
  { name = 'Surround: Change Surrounding, On Own Lines', keys = 'cS', pending = true },
  { name = 'Surround: Delete Surrounding', keys = 'ds', pending = true },

  -- vim-commentary
  { name = 'Comment: Toggle Line', keys = 'gcc' },
  { name = 'Comment: Toggle Motion', keys = 'gc', pending = true },
  { name = 'Comment: Toggle Selection', keys = 'gc', visual = true },
  { name = 'Comment: Toggle Paragraph', keys = 'gcap' },
  { name = 'Comment: Uncomment Adjacent Lines', keys = 'gcgc' },

  -- oil.nvim (the g-prefixed keys need an oil buffer to be focused)
  { name = 'Oil: Open Float', cmd = 'Oil --float' },
  { name = 'Oil: Open In Window', cmd = 'Oil' },
  { name = 'Oil: Open Directory', prompt = 'Oil ' },
  { name = 'Oil: Help (in oil buffer)', keys = 'g?' },
  { name = 'Oil: Toggle Hidden Files (in oil buffer)', keys = 'g.' },
  { name = 'Oil: Change Sort (in oil buffer)', keys = 'gs' },
  { name = 'Oil: Open Externally (in oil buffer)', keys = 'gx' },
  { name = 'Oil: Toggle Preview (in oil buffer)', keys = '<C-p>' },

  -- vim-gitgutter
  { name = 'Git: Next Hunk', keys = ']c' },
  { name = 'Git: Previous Hunk', keys = '[c' },
  { name = 'Git: Preview Hunk', keys = '<Leader>hp' },
  { name = 'Git: Stage Hunk', keys = '<Leader>hs' },
  { name = 'Git: Undo Hunk', keys = '<Leader>hu' },
  { name = 'Git: Hunks To Quickfix', cmd = 'GitGutterQuickFix' },
  { name = 'Git: Diff Against Index', cmd = 'GitGutterDiffOrig' },
  { name = 'Git: Fold Unchanged Lines', cmd = 'GitGutterFold' },
  { name = 'Git: Toggle Signs', cmd = 'GitGutterToggle' },
  { name = 'Git: Toggle Line Highlights', cmd = 'GitGutterLineHighlightsToggle' },

  -- Telescope pickers with no keybind
  { name = 'Find: Buffers', cmd = 'Telescope buffers' },
  { name = 'Find: Recent Files', cmd = 'Telescope oldfiles' },
  { name = 'Find: In Current Buffer', cmd = 'Telescope current_buffer_fuzzy_find' },
  { name = 'Find: Help Tags', cmd = 'Telescope help_tags' },
  { name = 'Find: Keymaps', cmd = 'Telescope keymaps' },
  { name = 'Find: Ex Commands', cmd = 'Telescope commands' },
  { name = 'Find: Marks', cmd = 'Telescope marks' },
  { name = 'Find: Registers', cmd = 'Telescope registers' },
  { name = 'Find: Jumplist', cmd = 'Telescope jumplist' },
  { name = 'Find: Quickfix', cmd = 'Telescope quickfix' },
  { name = 'Find: Search History', cmd = 'Telescope search_history' },
  { name = 'Find: Colorscheme', cmd = 'Telescope colorscheme' },
  { name = 'Find: Treesitter Symbols', cmd = 'Telescope treesitter' },
  { name = 'Git: Status', cmd = 'Telescope git_status' },
  { name = 'Git: Commits', cmd = 'Telescope git_commits' },
  { name = 'Git: Buffer Commits', cmd = 'Telescope git_bcommits' },
  { name = 'Git: Branches', cmd = 'Telescope git_branches' },
  { name = 'LSP: Document Symbols', cmd = 'Telescope lsp_document_symbols' },
  { name = 'LSP: Workspace Symbols', cmd = 'Telescope lsp_dynamic_workspace_symbols' },
  { name = 'LSP: Implementations', cmd = 'Telescope lsp_implementations' },
  { name = 'LSP: Incoming Calls', cmd = 'Telescope lsp_incoming_calls' },
  { name = 'LSP: Outgoing Calls', cmd = 'Telescope lsp_outgoing_calls' },

  -- Terminal (floaterm)
  { name = 'Terminal: New', cmd = 'FloatermNew' },
  { name = 'Terminal: New In Split', cmd = 'FloatermNew --wintype=split' },
  { name = 'Terminal: Next', cmd = 'FloatermNext' },
  { name = 'Terminal: Previous', cmd = 'FloatermPrev' },
  { name = 'Terminal: Kill Current', cmd = 'FloatermKill' },
  { name = 'Terminal: Run Command', prompt = 'FloatermNew ' },

  -- Buffer jumps (bufjump.nvim, otherwise unbound)
  { name = 'Jumps: Previous Buffer In Jumplist', run = function() require('bufjump').backward() end },
  { name = 'Jumps: Next Buffer In Jumplist', run = function() require('bufjump').forward() end },

  -- Built-ins that are useful but easy to forget
  { name = 'Edit: Increment Number', keys = '<C-a>' },
  { name = 'Edit: Decrement Number', keys = '<C-x>' },
  { name = 'Edit: Number Selection Sequentially', keys = 'g<C-a>', visual = true },
  { name = 'Edit: Join Without Space', keys = 'gJ' },
  { name = 'Edit: Format Motion', keys = 'gq', pending = true },
  { name = 'Edit: Uppercase Line', keys = 'gUU' },
  { name = 'Edit: Lowercase Line', keys = 'guu' },
  { name = 'Edit: Repeat Last Substitute On All Lines', keys = 'g&' },
  { name = 'Edit: Sort Lines', prompt = 'sort ' },
  { name = 'Edit: Filter Lines Through Command', prompt = '%!' },
  { name = 'Edit: Run Ex Command On Matching Lines', prompt = 'g//' },
  { name = 'Jumps: Older Change Position', keys = 'g;' },
  { name = 'Jumps: Newer Change Position', keys = 'g,' },
  { name = 'Jumps: Last Insert Position', keys = 'gi' },
  { name = 'Jumps: Reselect Last Selection', keys = 'gv' },
  { name = 'Jumps: Open File Under Cursor', keys = 'gf' },
  { name = 'Jumps: Open URL Under Cursor', keys = 'gx' },
  { name = 'Jumps: Matching Bracket', keys = '%' },
  { name = 'Jumps: Unmatched Opening Brace', keys = '[{' },
  { name = 'Jumps: Unmatched Closing Brace', keys = ']}' },
  { name = 'Undo: Go Back In Time', prompt = 'earlier 10m' },
  { name = 'Undo: Go Forward In Time', prompt = 'later 10m' },
  { name = 'Undo: List Undo States', cmd = 'undolist' },
  { name = 'Windows: Command-Line Window', keys = 'q:' },
  { name = 'Windows: Search History Window', keys = 'q/' },
  { name = 'Windows: Close All Others', keys = '<C-w>o' },
  { name = 'Windows: Equalize Sizes', keys = '<C-w>=' },
  { name = 'Windows: Maximize Height', keys = '<C-w>_' },
  { name = 'Windows: Exchange With Next', keys = '<C-w>x' },
  { name = 'Windows: Rotate', keys = '<C-w>r' },
  { name = 'Windows: Move To New Tab', keys = '<C-w>T' },
  { name = 'Folds: Toggle Under Cursor', keys = 'za' },
  { name = 'Folds: Open All', keys = 'zR' },
  { name = 'Folds: Close All', keys = 'zM' },
  { name = 'Folds: Create From Motion', keys = 'zf', pending = true },
  { name = 'Spell: Suggest Correction', keys = 'z=' },
  { name = 'Spell: Add Word To Dictionary', keys = 'zg' },
  { name = 'Spell: Next Misspelling', keys = ']s' },
  { name = 'Spell: Toggle Spell Check', cmd = 'setlocal spell!' },
  { name = 'Quickfix: Open List', cmd = 'copen' },
  { name = 'Quickfix: Next Item', cmd = 'cnext' },
  { name = 'Quickfix: Previous Item', cmd = 'cprevious' },
  { name = 'Diff: Diff This Window', cmd = 'diffthis' },
  { name = 'Diff: Diff All Windows', cmd = 'windo diffthis' },
  { name = 'Diff: Turn Off', cmd = 'diffoff!' },
  { name = 'Inspect: Show Message History', keys = 'g<' },
  { name = 'Inspect: Character Code Under Cursor', keys = 'ga' },
  { name = 'Inspect: Highlight Groups Under Cursor', cmd = 'Inspect' },
  { name = 'Inspect: Treesitter Tree', cmd = 'InspectTree' },
  { name = 'Inspect: Checkhealth', prompt = 'checkhealth ' },
  { name = 'Buffers: Clear Search Highlight', cmd = 'nohlsearch' },
  { name = 'Buffers: Reload From Disk', cmd = 'edit!' },
  { name = 'Buffers: Toggle Invisible Characters', cmd = 'setlocal list!' },
  { name = 'Buffers: Toggle Wrap', cmd = 'setlocal wrap!' },
  { name = 'Buffers: Toggle Indent Guides', cmd = 'IBLToggle' },
  { name = 'Buffers: Toggle Scrollbar', cmd = 'ScrollViewToggle' },
  { name = 'Treesitter: Install Parser', prompt = 'TSInstall ' },
  { name = 'Treesitter: Update Parsers', cmd = 'TSUpdate' },
  { name = 'Fun: Make It Rain', cmd = 'CellularAutomaton make_it_rain' },
  { name = 'Fun: Game Of Life', cmd = 'CellularAutomaton game_of_life' },
}

local function palette_entry(item)
  if item.run then
    return { name = item.name, lhs = item.lhs or '', action = item.run }
  end
  if item.cmd then
    return { name = item.name, lhs = ':' .. item.cmd, action = function() vim.cmd(item.cmd) end }
  end
  if item.prompt then
    return {
      name = item.name,
      lhs = ':' .. item.prompt,
      action = function() vim.api.nvim_input(':' .. item.prompt) end,
    }
  end

  local keys = (item.visual and 'gv' or '') .. item.keys
  local action
  if item.pending then
    -- Leave the sequence unfinished so the rest can be typed: ys{motion}{char}.
    action = function()
      vim.api.nvim_input(vim.api.nvim_replace_termcodes(keys, true, false, true))
    end
  else
    action = replay_keys(keys)
  end
  local lhs = (item.visual and 'v_' or '') .. item.keys .. (item.pending and '…' or '')
  return { name = item.name, lhs = lhs, action = action }
end

local curated_commands = vim.tbl_map(palette_entry, curated)

local function open_command_palette()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local entry_display = require('telescope.pickers.entry_display')

  local commands = {}
  vim.list_extend(commands, keymap_registry)
  vim.list_extend(commands, curated_commands)

  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 44 },
      { remaining = true },
    },
  })

  local function make_display(entry)
    local cmd = entry.value
    return displayer({
      cmd.name,
      { cmd.lhs or '', 'Comment' },
    })
  end

  pickers.new({}, {
    prompt_title = 'Command Palette',
    finder = finders.new_table({
      results = commands,
      entry_maker = function(entry)
        return {
          value = entry,
          display = make_display,
          ordinal = entry.name .. ' ' .. (entry.lhs or ''),
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          selection.value.action()
        end
      end)
      return true
    end,
  }):find()
end

bind('n', '<C-S-p>', open_command_palette, 'Open Command Palette')

-- OPTIONS --
-- Performance
o.lazyredraw = true;
o.shell = "bash"
o.shellcmdflag = "-c"
o.shellquote = ""
o.shellxquote = ""
o.shadafile = "NONE"

-- Colors
o.termguicolors = true

-- Undo files
o.undofile = true

-- Indentation
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4
o.shiftround = true;
o.expandtab = true
o.scrolloff = 3

-- Set clipboard to use system clipboard
o.clipboard = "unnamedplus"

-- Use mouse
o.mouse = "a"

-- Nicer UI settings
o.cursorline = true
o.relativenumber = true
o.number = true

-- Get rid of annoying viminfo file
o.viminfo = ""
o.viminfofile = "NONE"

-- Miscellaneous quality of life
o.ignorecase = true
o.ttimeoutlen = 5
o.hidden = true
o.shortmess = "atI"
o.wrap = false
o.backup = false
o.writebackup = false
o.errorbells = false
o.swapfile = false
o.showmode = false
o.laststatus = 3
o.pumheight = 6
o.splitright = true
o.splitbelow = true
o.completeopt = "menuone,noselect"

-- Neovide
if vim.g.neovide then
    vim.g.neovide_cursor_vfx_mode = "wireframe"
    vim.keymap.set('v', '<C-c>', '"+y') -- Copy
    vim.keymap.set('n', '<C-v>', '"+P') -- Paste normal mode
    vim.keymap.set('v', '<C-v>', '"+P') -- Paste visual mode
    vim.keymap.set('c', '<C-v>', '<C-R>+') -- Paste command mode
    vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli') -- Paste insert mode
end
