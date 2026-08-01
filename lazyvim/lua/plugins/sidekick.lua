-- ~/.config/nvim/lua/plugins/sidekick.lua
return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      tools = {
        claude = {
          cmd = { "claude", "--dangerously-skip-permissions" },
        },
        omp = {
          cmd = { "omp" },
          is_proc = "\\",
          resume = { "--resume" },
          continue = { "--resume" },
          native_scroll = false,
        },
        ["opencode-chatgpt"] = {
          cmd = { "opencode" },
          env = {
            OPENCODE_CONFIG = "/home/diru/.config/opencode/profiles/chatgpt-go.json",
            OPENCODE_THEME = "system",
          },
          keys = {
            prompt = { "<a-p>", "prompt" },
          },
          is_proc = "\\<opencode\\>",
          continue = { "--continue" },
          native_scroll = true,
        },
        ["opencode-go"] = {
          cmd = { "opencode" },
          env = {
            OPENCODE_CONFIG = "/home/diru/.config/opencode/profiles/go-only.json",
            OPENCODE_THEME = "system",
          },
          keys = {
            prompt = { "<a-p>", "prompt" },
          },
          is_proc = "\\<opencode\\>",
          continue = { "--continue" },
          native_scroll = true,
        },
      },
    },
  },
}
