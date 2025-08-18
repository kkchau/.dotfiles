local M = {}
local lspconfig = require("lspconfig")

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
}

lspconfig.lua_ls.setup(config)

return M
