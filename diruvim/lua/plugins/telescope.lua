return {
  'nvim-telescope/telescope.nvim', version = '*',
	keys = {
    { "<leader>ff" },
    { "<leader>fg" },
    { "<leader>fb" },
    { "<leader>fh" },
    { "<leader>fr" },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- optional but recommended
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        cache_picker = {
          num_pickers = 5,
        },
      },
    })

    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Telescope resume last' })
  end,
}
