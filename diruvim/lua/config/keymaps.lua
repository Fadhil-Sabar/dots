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

-- Resize window
map("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("v", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("i", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>wc", "<cmd>close<cr>", { desc = "Close window" })
map("n", "<leader>wx", "<cmd>cclose | lclose<cr>", { desc = "Close Quickfix/Location List" })

map("n", "<leader>sp", "<cmd>PrayerTime<cr>", { desc = "Jadwal sholat" })

map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Switch to last buffer" })
map("n", "<leader>bd", "<cmd>bnext | bdelete #<cr>", { desc = "Close buffer (keep window)" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

map("n", "<leader>uf", "<cmd>FormatToggle<cr>", { desc = "Toggle format on save" })

map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore last session" })
map("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Stop saving session for this dir" })

map("n", "<leader>ss", function()
  local ok, err = pcall(function()
    require("persistence").save()
  end)
  
  if ok then
    vim.notify("✅ Session tersimpan di: " .. vim.fn.stdpath("data") .. "/sessions/", vim.log.levels.INFO)
  else
    vim.notify("❌ Error: " .. tostring(err), vim.log.levels.ERROR)
  end
end, { desc = "Save Session" })

-- Terminal toggle (Ctrl+` like VS Code)
local all_terminals = {}

local function get_valid_terminals()
  all_terminals = vim.tbl_filter(function(t)
    return t ~= nil and vim.api.nvim_buf_is_valid(t.buf)
  end, all_terminals)
  return all_terminals
end

map({ "n", "t" }, "<C-`>", function()
  local terms = get_valid_terminals()

  if #terms == 0 then
    -- No terminals yet, create one
    vim.cmd("botright split | resize 15 | terminal")
    table.insert(all_terminals, {
      buf = vim.api.nvim_get_current_buf(),
      win = vim.api.nvim_get_current_win(),
    })
    vim.cmd("startinsert")
    return
  end

  -- Check if any terminal window is visible
  local any_visible = false
  for _, t in ipairs(terms) do
    if t.win and vim.api.nvim_win_is_valid(t.win) then
      any_visible = true
      break
    end
  end

  if any_visible then
    -- Hide all terminals
    for _, t in ipairs(terms) do
      if t.win and vim.api.nvim_win_is_valid(t.win) then
        vim.api.nvim_win_close(t.win, true)
        t.win = nil
      end
    end
  else
    -- Show all terminals in splits
    if #terms == 1 then
      -- Single terminal: just split horizontally
      vim.cmd("botright split")
      terms[1].win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(terms[1].win, terms[1].buf)
      vim.cmd("resize 15")
    elseif #terms == 2 then
      -- Two terminals: create horizontal split, then vsplit within it
      vim.cmd("botright split")
      local base_win = vim.api.nvim_get_current_win()
      vim.cmd("resize 15")
      
      -- First terminal goes left
      terms[1].win = base_win
      vim.api.nvim_win_set_buf(base_win, terms[1].buf)
      
      -- Second terminal goes right
      vim.cmd("vsplit")
      terms[2].win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(terms[2].win, terms[2].buf)
    else
      -- 3+ terminals: use vertical splits
      for i, t in ipairs(terms) do
        vim.cmd("botright split")
        t.win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(t.win, t.buf)
        vim.cmd("resize 15")
      end
    end
    vim.cmd("startinsert")
  end
end, { desc = "Toggle All Terminals" })

-- Ctrl+Shift+` to open a NEW terminal (vsplit within terminal row)
map({ "n", "t" }, "<C-S-`>", function()
  local terms = get_valid_terminals()

  -- Find an existing visible terminal window to split from
  local target_win = nil
  for _, t in ipairs(terms) do
    if t.win and vim.api.nvim_win_is_valid(t.win) then
      target_win = t.win
      break
    end
  end

  if target_win then
    -- Focus the terminal window, then vsplit from there (splits only the terminal row)
    vim.api.nvim_set_current_win(target_win)
    vim.cmd("vsplit | terminal")
  else
    -- No visible terminal, create a fresh one at the bottom
    vim.cmd("botright split | resize 15 | terminal")
  end

  table.insert(all_terminals, {
    buf = vim.api.nvim_get_current_buf(),
    win = vim.api.nvim_get_current_win(),
  })
  vim.cmd("startinsert")
end, { desc = "New Terminal" })
