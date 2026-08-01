return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = {
      "lua",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "markdown",
      "markdown_inline",
      "go",
      "gomod",
      "gosum",
      "go.work",
    }

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("diruvim-treesitter", { clear = true }),
      pattern = {
        "lua",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "css",
        "json",
        "markdown",
        "go",
        "gomod",
        "gosum",
        "go.work",
      },
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
