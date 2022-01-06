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
                "json",
                "lua",
                "markdown",
                "python",
                "rust",
                "toml",
                "yaml",
            },
        }
    )

end

return M
