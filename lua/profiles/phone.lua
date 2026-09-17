-- Independent of desktop settings (especially its shell and clipboard setup).
vim.g.mapleader = ' '
local o = vim.opt
o.termguicolors = true
o.number = false
o.relativenumber = false
o.signcolumn = 'yes:1'
o.wrap = true
o.linebreak = true
o.scrolloff = 2
o.laststatus = 3
o.showmode = false
o.pumheight = 5
o.ignorecase = true
o.smartcase = true
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.smartindent = true
o.shortmess:append('I') -- Suppress Neovim's startup intro.
o.timeoutlen = 1000
vim.diagnostic.config({ virtual_text = false, float = { border = 'single' } })

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
end
map('<leader>w', '<cmd>write<cr>', 'Save')
map('<leader>q', '<cmd>quit<cr>', 'Quit window')
map('<leader>h', '<cmd>nohlsearch<cr>', 'Clear search highlight')
map('<leader>p', '<cmd>PiAsk<cr>', 'Pi: Ask')
map('<leader>l', '<cmd>PiLog<cr>', 'Pi: Session log')
map('<leader>i', '<cmd>PiNew<cr>', 'Pi: New session')
-- Disable the built-in window-command prefix in normal mode.
-- Insert-mode Ctrl-W still deletes the previous word.
map('<C-w>', '<Nop>', 'Window shortcuts disabled in phone mode')

-- Keep PlugClean scoped to this profile. Shared declarations are installed
-- separately so switching profiles cannot delete the desktop plugin set.
local ok, err = pcall(vim.call, 'plug#begin', vim.fn.stdpath('data') .. '/plugged-phone')
if not ok then
  vim.notify('Phone mode needs vim-plug: ' .. tostring(err), vim.log.levels.WARN)
  return
end
require('shared.plugins')(vim.fn['plug#'])
-- Add phone-only Plug declarations here.
vim.call('plug#end')
require('shared.notify')

-- Allow first startup before :PlugInstall; report missing dependencies once.
local missing = {}
local function setup(name, callback)
  local loaded, module = pcall(require, name)
  if loaded then
    callback(module)
  else
    table.insert(missing, name)
  end
end

setup('catppuccin', function()
  require('colors')
end)
setup('oil', function(oil)
  oil.setup({
    default_file_explorer = true,
    columns = {}, -- No file icons needed in the phone terminal.
    keymaps = {
      ['.'] = { 'actions.parent', mode = 'n' },
      ['<C-s>'] = false, -- Disable Oil's split-opening shortcuts.
      ['<C-h>'] = false,
    },
  })
  map('.', oil.open, 'Open Oil')
end)
setup('lualine', function(lualine)
  lualine.setup({
    options = {
      theme = 'powerline_dark',
      icons_enabled = false,
      component_separators = '',
      section_separators = '',
    },
    sections = {
      lualine_a = { { 'mode', fmt = function(mode) return mode:sub(1, 1) end } },
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
  })
end)
setup('telescope', function(telescope)
  telescope.setup({
    defaults = {
      layout_strategy = 'vertical',
      layout_config = { width = 0.98, height = 0.95 },
      preview = false,
      disable_devicons = true,
      mappings = {
        i = { ['<C-x>'] = false, ['<C-v>'] = false },
        n = { ['<C-x>'] = false, ['<C-v>'] = false },
      },
    },
  })
  local builtin = require('telescope.builtin')
  map('<leader>f', builtin.find_files, 'Find files')
  map('<leader>n', builtin.live_grep, 'Ripgrep')
  map('<leader>e', function()
    builtin.diagnostics({ bufnr = nil, severity = vim.diagnostic.severity.ERROR })
  end, 'Find all errors')
  map('<leader>d', function()
    builtin.diagnostics({ bufnr = nil })
  end, 'Find all diagnostics')
  map('gd', builtin.lsp_definitions, 'Go to definition')
  map('gt', builtin.lsp_type_definitions, 'Go to type definition')
  map('gr', builtin.lsp_references, 'Find references')
end)
setup('lspconfig', function()
  local servers = {
  nil_ls = { command = 'nil', settings = {} },
  rust_analyzer = { command = 'rust-analyzer', settings = {} },
  }

  for name, server in pairs(servers) do
  if vim.fn.executable(server.command) == 1 then
    local opts = { settings = server.settings }
    if vim.lsp.config and vim.lsp.enable then
      vim.lsp.config(name, opts)
      vim.lsp.enable(name)
    else
      require('lspconfig')[name].setup(opts)
    end
  end
  end
end)
if #missing > 0 then
  vim.notify('Phone mode: run :PlugInstall and restart. Missing: ' .. table.concat(missing, ', '), vim.log.levels.WARN)
end
