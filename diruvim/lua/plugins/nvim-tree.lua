return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    { "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "Focus file explorer" },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
			on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- load semua default keymaps dulu
        api.config.mappings.default_on_attach(bufnr)

        -- hapus s
        vim.keymap.del("n", "s", { buffer = bufnr })

        -- l untuk buka folder/file, h untuk collapse
        vim.keymap.set("n", "l", api.node.open.edit, { buffer = bufnr, desc = "Open" })
        vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = bufnr, desc = "Collapse" })
      end,
			update_focused_file = {
				enable = true,      -- auto focus ke file yang sedang dibuka
				update_root = false,
			},
		}
  end,
}
