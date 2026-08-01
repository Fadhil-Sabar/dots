return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = { "<C-d>", { "<C-d>", mode = "x" } },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Next"] = "<C-d>",
      }
    end,
  },
}
