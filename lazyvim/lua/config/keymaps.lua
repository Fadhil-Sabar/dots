-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


vim.keymap.set("i", "<C-s>", "<cmd>w<cr>", { desc = "Save File" })

vim.keymap.set("n", "<C-S-k>", "dd", { desc = "Delete line" })

-- vim.keymap.set('n', 'j', 'k')
-- vim.keymap.set('n', 'k', 'j')
-- vim.keymap.set('v', 'j', 'k')
-- vim.keymap.set('v', 'k', 'j')
