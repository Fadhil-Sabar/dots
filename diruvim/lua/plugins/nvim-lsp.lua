return {
  -- Mason: install & manage LSP servers
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- Bridge antara Mason dan lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
		event = "BufReadPre",
    opts = {
      ensure_installed = {
        "lua_ls",    -- Lua
      },
    },
  },

  -- nvim-lspconfig: koneksi ke LSP servers
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.enable("lua_ls")
    end,
  },
}
