return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "arctic",
    },
  },

  {
    "rockyzhang24/arctic.nvim",
    lazy = false,
    branch = "v2",
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
  },
}
