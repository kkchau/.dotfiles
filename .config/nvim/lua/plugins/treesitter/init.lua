local M = {}
M.__index = M

function M.init()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup(
        {
            highlight = {enable = true},
            indent = {enable = true},
            ensure_installed = {
                "bash",
                "dockerfile",
                "json",
                "lua",
                "markdown",
                "mermaid",
                "proto",
                "python",
                "r",
                "rust",
                "sql",
                "toml",
                "yaml",
            },
        }
    )

end

return M
