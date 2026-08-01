-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


vim.keymap.set("i", "<C-s>", "<cmd>w<cr>", { desc = "Save File" })

vim.keymap.set("n", "<C-S-k>", "dd", { desc = "Delete line" })

-- Ctrl+P to open file picker (same as <leader>ff)
vim.keymap.set("n", "<C-p>", LazyVim.pick("files"), { desc = "Find Files (Root Dir)" })

-- Track all terminals we create so we can show/hide them all together
local all_terminals = {}

-- Ctrl+` to show/hide ALL terminals at once (VS Code-style)
vim.keymap.set({ "n", "t" }, "<C-`>", function()
  -- Remove any collected/invalid terminals
  all_terminals = vim.tbl_filter(function(t)
    return t ~= nil and t:buf_valid()
  end, all_terminals)

  if #all_terminals == 0 then
    -- No terminals yet, create the first one
    local t = Snacks.terminal.open(nil, { cwd = LazyVim.root(), count = 1 })
    table.insert(all_terminals, t)
    return
  end

  -- Check if any terminal window is currently visible
  local any_visible = false
  for _, t in ipairs(all_terminals) do
    if t:win_valid() then
      any_visible = true
      break
    end
  end

  -- Toggle all: show all or hide all
  for _, t in ipairs(all_terminals) do
    pcall(any_visible and t.hide or t.show, t)
  end
end, { desc = "Toggle All Terminals" })

-- Ctrl+Shift+` to open a NEW terminal (adds to the managed list)
local term_counter = 1
vim.keymap.set({ "n", "t" }, "<C-S-`>", function()
  term_counter = term_counter + 1
  local t = Snacks.terminal.open(nil, { cwd = LazyVim.root(), count = term_counter })
  table.insert(all_terminals, t)
end, { desc = "New Terminal" })
