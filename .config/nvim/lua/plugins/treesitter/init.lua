local M = {}
M.__index = M

function M.init()
    local treesitter = require("nvim-treesitter")

    treesitter.setup(
        {
            highlight = {
                enable = true,
                disable = {},
            },
            indent = {
                enable = false,
                disable = {},
            },
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
