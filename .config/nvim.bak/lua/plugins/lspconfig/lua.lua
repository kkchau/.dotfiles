local M = {}

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

vim.lsp.config('lua_ls', config)

return M
