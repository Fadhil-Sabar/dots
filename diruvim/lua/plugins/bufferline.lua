return {'akinsho/bufferline.nvim', version = "*",
  event = "VeryLazy",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup({
      options = {
        custom_filter = function(bufnr)
          return vim.bo[bufnr].buftype ~= "terminal"
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
      },
    })
  end,
}
