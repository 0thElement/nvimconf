-- Declare shared plugins; each profile owns its setup and install directory.
return function(Plug)
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
  Plug('nvim-telescope/telescope.nvim', { tag = '0.1.8' })
  Plug 'neovim/nvim-lspconfig'
  Plug 'stevearc/oil.nvim'
  Plug 'echasnovski/mini.notify'
end
