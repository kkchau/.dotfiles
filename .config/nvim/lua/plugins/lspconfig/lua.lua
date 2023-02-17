local M = {}
local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")

local config = {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            telemetry = {
                workspace = { checkThirdParty = false },
                enable = false,
            }
        }
    },
    flags = { debounce_text_changes = 500 },
    on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
    end,
}

lspconfig.lua_ls.setup(config)

return M
