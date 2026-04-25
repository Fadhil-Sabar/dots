-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false
vim.g.lazygit_config = false

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
  desc = "Disable auto-commenting on Enter",
})

-- Memaksa format tanpa memicu plugin tertentu jika perlu
vim.keymap.set("n", "<leader>f", function()
  require("lazyvim.util").format({ force = true })
end, { desc = "Format Document" })

vim.opt.linebreak = true
vim.opt.autoindent = true
-- vim.opt.relativenumber = false
vim.opt.shortmess:append("c")  -- suppress beberapa pesan
vim.opt.report = 999            -- hanya tampilkan yank jika > 999 baris
