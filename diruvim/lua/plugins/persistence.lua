return {
  "folke/persistence.nvim",
  event = "VimEnter",
  init = function()
    -- persistence.nvim no longer reads session options from its setup table.
    -- In particular, exclude `blank` so plugin windows such as NvimTree are
    -- not restored as empty splits.
    vim.opt.sessionoptions = {
      "buffers",
      "curdir",
      "folds",
      "help",
      "tabpages",
      "winsize",
      "globals",
      "skiprtp",
    }
  end,
  opts = {
    dir = vim.fn.stdpath("data") .. "/sessions", -- Otomatis jadi ~/.local/share/diruvim/sessions
  },
  config = function(_, opts)
    require("persistence").setup(opts)

    local reopen_tree_after_save = false

    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        local api = package.loaded["nvim-tree.api"]
        local tree_is_open = api ~= nil and api.tree.is_visible({ any_tabpage = true })

        vim.g.DiruNvimTreeOpen = tree_is_open and 1 or 0
        vim.g.DiruNvimTreeFocused = tree_is_open and api.tree.is_tree_buf(0) and 1 or 0
        reopen_tree_after_save = tree_is_open

        if tree_is_open then
          api.tree.close_in_all_tabs()
        end
      end,
    })

    -- Keep manual session saves from visibly closing the explorer.
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePost",
      callback = function()
        if reopen_tree_after_save then
          vim.schedule(function()
            require("nvim-tree.api").tree.open()
          end)
        end
        reopen_tree_after_save = false
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        if vim.g.DiruNvimTreeOpen ~= 1 then
          return
        end

        vim.schedule(function()
          local previous_window = vim.api.nvim_get_current_win()
          require("nvim-tree.api").tree.open()

          if vim.g.DiruNvimTreeFocused ~= 1 and vim.api.nvim_win_is_valid(previous_window) then
            vim.api.nvim_set_current_win(previous_window)
          end
        end)
      end,
    })
  end,
}
