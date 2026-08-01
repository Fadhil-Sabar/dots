return {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>gg", function()
            local file_dir = vim.fn.expand("%:p:h")
            local git_root = vim.fn.system("git -C " .. file_dir .. " rev-parse --show-toplevel"):gsub("\n", "")
            if vim.v.shell_error == 0 and git_root ~= "" then
                vim.cmd("cd " .. git_root)
                vim.cmd("LazyGit")
            else
                vim.notify("Not in a git repository", vim.log.levels.WARN)
            end
        end, desc = "LazyGit" }
    }
}
