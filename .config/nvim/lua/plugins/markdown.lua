-- Plugins for working with Markdown files
vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-mini/mini.nvim',
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',
})
vim.pack.add({
    { src='https://github.com/toppair/peek.nvim' }
})
vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
