return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require("lualine").setup({
				sections = {
					lualine_x = {
						{ require("config.prayer").get_next_prayer },
						"encoding",
						"fileformat",
						"filetype",
						function()
							return os.date("%H:%M")
						end,
					},
				},
			})
	end,
}
