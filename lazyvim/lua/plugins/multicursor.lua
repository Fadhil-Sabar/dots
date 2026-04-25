return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      -- Opsional: mapping agar lebih mirip VSCode
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Next"] = "<C-d>",
      }
    end,
  },
}
