return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofumpt", "goimports" },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    },
    config = function(_, opts)
      -- Start with format-on-save disabled. Use <leader>uf or :FormatEnable to enable it.
      vim.g.disable_autoformat = true

      local conform = require("conform")
      conform.setup(opts)

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
        vim.notify("Autoformat disabled")
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
        vim.notify("Autoformat enabled")
      end, {
        desc = "Re-enable autoformat-on-save",
      })

      vim.api.nvim_create_user_command("FormatToggle", function()
        if vim.g.disable_autoformat then
          vim.g.disable_autoformat = false
          vim.notify("Autoformat enabled (global)")
        else
          vim.g.disable_autoformat = true
          vim.notify("Autoformat disabled (global)")
        end
      end, {
        desc = "Toggle autoformat-on-save",
      })
    end,
  },
}
