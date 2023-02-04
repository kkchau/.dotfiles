local M = {}
M.__index = M

function M.init()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    local servers = {
        rust_analyzer = {},
        pyright = {}
    }


    mason.setup()
    mason_lspconfig.setup(
        {
            ensure_installed = vim.tbl_keys(servers)
        }
    )
end

return M
