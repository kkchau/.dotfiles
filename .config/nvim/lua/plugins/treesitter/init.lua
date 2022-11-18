local M = {}
M.__index = M

function M.init()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup(
        {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "bash",
                "dockerfile",
                "json",
                "lua",
                "lua",
                "luadoc",
                "markdown",
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
            },
        }
    )
end

return M
