return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "arctic",
      autoformat = false,
    },
  },

  {
    "rockyzhang24/arctic.nvim",
    branch = "v2",
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
  },
}
