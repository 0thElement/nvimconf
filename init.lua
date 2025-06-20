local vim = vim
local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug "nvim-lua/plenary.nvim"
Plug 'nvim-lualine/lualine.nvim'
Plug 'airblade/vim-gitgutter'
Plug ('catppuccin/nvim', { ['as'] = "catppuccin" })
Plug 'nvim-tree/nvim-web-devicons'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug ('dstein64/nvim-scrollview', { ['branch'] = 'main' })
Plug 'stevearc/oil.nvim'
Plug ('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.8' })
Plug ('ThePrimeagen/harpoon', { ['branch'] = 'harpoon2' })
Plug 'voldikss/vim-floaterm'
Plug 'neovim/nvim-lspconfig'
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
Plug ('filipdutescu/renamer.nvim', { ['branch'] = 'master' })
Plug 'onsails/lspkind.nvim'
Plug 'mrcjkb/rustaceanvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-calc'
Plug 'DingDean/wgsl.vim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'aznhe21/actions-preview.nvim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'kwkarlwang/bufjump.nvim'
Plug 'Eandrju/cellular-automaton.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
vim.call('plug#end')

local function trim(s)
  local l = 1
  while string.sub(s,l,l) == ' ' do
    l = l+1
  end
  local r = string.len(s)
  while string.sub(s,r,r) == ' ' do
    r = r-1
  end
  return string.sub(s,l,r)
end

local function limit(str, len)
  if string.len(str) > len + 1 then
    return string.sub(str, 0, len - 3)..'…'
  else
    return str
  end
end

local function registers()
  local origunmd =  vim.fn.getreg('"')
  local origbkup =  vim.fn.getreg('0')
  local unmdreg = trim(limit(trim(origunmd), 20))
  local bkupreg = trim(limit(trim(origbkup), 20))
  if origunmd ~= origbkup then
    return " "..unmdreg.." ⇿ "..bkupreg
  else 
    return " "..unmdreg
  end
end

local spinner = {
  "▪▫▫▫",
  "▪▫▫▫",
  "▪▫▫▫",
  "▪▪▫▫",
  "▫▪▪▫",
  "▫▫▪▪",
  "▫▫▫▪",
  "▫▫▫▪",
  "▫▫▫▪",
  "▫▫▪▪",
  "▫▪▪▫",
  "▪▪▫▫",
}

local snail = require 'snail'
local mysnail = snail.new_snail()
local snailopts = snail.default_opts
local function walksnail()
  mysnail = snail.walk(mysnail, snailopts)
  return snail.show(mysnail, snailopts)
end
require('lualine').setup({
  theme = 'powerline-dark',
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {registers},
    lualine_y = {'filetype', {'lsp_status', icon = '', symbols = { spinner = spinner, done = '✓'}, separator = ''}},
    lualine_z = {walksnail}
  },
})

require('nvim-web-devicons').setup()
require('ibl').setup()
require('scrollview').setup()
require('oil').setup({
  default_file_explorer = true,
  win_options = {
    wrap = true
  },
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _) return name == '..' or name == '.git' end,
  },
})

require('telescope').setup()
require('harpoon').setup()
vim.cmd [[let g:floaterm_borderchars = "─│─│╭╮╯╰"]]
vim.cmd [[let g:floaterm_titleposition = "center"]]
vim.cmd [[let g:floaterm_width = 0.99]]
vim.cmd [[let g:floaterm_height = 0.95]]
vim.cmd [[let g:floaterm_title = " Terminal $1/$2 "]]
vim.cmd [[hi link FloatermBorder FloatBorder]]

-- vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
-- vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

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

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.wgsl",

  callback = function()
    vim.bo.filetype = "wgsl"
  end,
})

require('lspconfig').nil_ls.setup({})

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        cargo = {
          allTargets = true,
          features = "all"
        }
      },
    },
  },
}

require('lsp_signature').setup()
require('renamer').setup({ min_width = 20, padding = { left = 1, right = 1 } })
vim.cmd [[hi link RenamerBorder FloatBorder]]
vim.cmd [[hi link RenamerTitle FloatBorder]]

require('nvim-lightbulb').setup({
  autocmd = { enabled = true },
  sign = { enabled = false },
  virtual_text = {
    enabled = true,
    pos = "eol",
    hl = "",
  }
})

require("actions-preview").setup {
  telescope = {
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.8,
      height = 0.9,
      prompt_position = "top",
      preview_cutoff = 20,
      preview_height = function(_, _, max_lines)
        return max_lines - 15
      end,
    },
  },
}

vim.cmd[[let g:VM_theme = 'nord']]
vim.cmd[[let g:VM_maps = {}]]
vim.cmd[[let g:VM_maps['Find Under']         = ""]]
vim.cmd[[let g:VM_maps['Find Subword Under'] = ""]]

require "settings"
require "cmpsettings"
require "colors"
require "bedtime".setup()