-- Persist last search query per picker source.
-- When you open a picker (e.g. <leader>ff for files), type a query, close it,
-- then open the same picker again, your last query is restored.
return {
  "folke/snacks.nvim",
  config = function()
    if not Snacks or not Snacks.picker then
      vim.schedule(function()
        require("config.last_search").setup()
      end)
      return
    end
    require("config.last_search").setup()
  end,
}
