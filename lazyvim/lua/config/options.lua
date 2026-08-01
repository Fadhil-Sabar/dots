-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false

-- Sync yanks with system clipboard
vim.opt.clipboard = "unnamedplus"
vim.g.lazygit_config = false

vim.env.DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1"

vim.opt.linebreak = true
vim.opt.report = 999
vim.g.snacks_animate = true
vim.g.snacks_scroll = true
