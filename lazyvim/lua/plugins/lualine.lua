return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Remove trouble.nvim from lualine's x section to avoid loading it at startup
    opts.sections = opts.sections or {}
    opts.sections.lualine_x = { "encoding", "fileformat", "filetype" }
    return opts
  end,
}
