return {
  "rockyzhang24/arctic.nvim",
  branch = "v2",
  dependencies = { "rktjmp/lush.nvim" },
  priority = 1000,
  lazy = false,
  config = function()
    vim.cmd.colorscheme "arctic"
  end,
}
