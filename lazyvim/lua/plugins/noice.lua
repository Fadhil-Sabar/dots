return {
  "folke/noice.nvim",
  opts = {
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "Already at newest change" },
            { find = "Already at oldest change" },
          },
        },
        opts = { skip = true },
      },
    },
  },
}
