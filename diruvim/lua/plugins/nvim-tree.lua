return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
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
      end,
			update_focused_file = {
				enable = true,      -- auto focus ke file yang sedang dibuka
				update_root = false,
			},
		}
  end,
}
