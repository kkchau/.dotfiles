local M = {}
M.__index = M

function M.init()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    -- Define servers here. Table of empty tables since I'm defining the configs
    -- under the lspconfig section.
    local servers = {
        bashls = {},
        gopls = {},
        lua_ls = {},
        pyright = {},
        rust_analyzer = {},
    }


    mason.setup()
    mason_lspconfig.setup(
        {
            ensure_installed = vim.tbl_keys(servers)
        }
    )
end

return M
