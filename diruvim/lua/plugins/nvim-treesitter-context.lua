return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesitter-context").setup({
      enable = true,
      max_lines = 3,        -- maksimal 3 baris context di atas
      trim_scope = "outer",
    })

    -- shortcut jump ke context
    vim.keymap.set("n", "[c", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { desc = "Jump to context" })
  end,
}
