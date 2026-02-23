-- Treesitter
vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' }
})
local treesitter = require('nvim-treesitter')
treesitter.install({
    "bash",
    "dockerfile",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "mermaid",
    "proto",
    "python",
    "query",
    "r",
    "rust",
    "sql",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
})
