local map = vim.keymap.set

-- Leader key (pastikan ini di lazy.lua sudah ada, tapi double check)
vim.g.mapleader = " "

-- Nvim-tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
map("n", "<leader>o", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file explorer" })

map("n", "d", '"_d', { desc = "Delete without register" })
map("v", "d", '"_d', { desc = "Delete without register" })
map("n", "c", '"_c', { desc = "Change without register" })
map("v", "c", '"_c', { desc = "Change without register" })

map("n", "<C-h>", "<C-w>h", { desc = "Focus left" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus down" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus up" })

map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("v", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("i", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

map("n", "<leader>sp", "<cmd>PrayerTime<cr>", { desc = "Jadwal sholat" })
