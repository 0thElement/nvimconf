-- Any present value (including "0" or an empty string) selects phone mode.
vim.g.phone_mode = vim.env.NVIM_PHONE_MODE ~= nil
require(vim.g.phone_mode and 'profiles.phone' or 'profiles.desktop')
