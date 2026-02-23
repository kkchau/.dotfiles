-- Treesitter
vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/nvim-treesitter/nvim-treesitter-context'
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
