return {
  'akinsho/bufferline.nvim',
  version = "*",  -- gunakan versi stabil
  dependencies = { 
    'nvim-tree/nvim-web-devicons',  -- untuk ikon berwarna
    'echasnovski/mini.icons'        -- alternatif jika tidak pakai nvim-web-devicons
  },
  config = function()
    require("bufferline").setup({
      options = {
        custom_filter = function(bufnr)
          return vim.bo[bufnr].buftype ~= "terminal"
        end,
        mode = "buffers",           -- tampilkan buffers
        style_preset = 1,           -- gaya tab (1-4)
        themable = true,            -- bisa di-theme
        numbers = "none",           -- atau "ordinal" / "buffer_id"
        close_command = "bdelete! %d",  -- command saat klik close icon
        right_mouse_command = "bdelete! %d",
        diagnostics = false,        -- atau "nvim_lsp" untuk indikator error
        show_tab_indicators = true,
        show_buffer_close_icons = true,
        separator_style = "slant",  -- atau "slope", "padded_slant", "bar"
        enforce_regular_tabs = false,
        always_show_bufferline = true,
      },
    })
  end,
}
