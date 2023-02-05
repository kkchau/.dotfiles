local M = {}
local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")

local config = {
    settings = lspconfig.pyright.settings,
    flags = { debounce_text_changes = 500 },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        lsp.on_attach(client, bufnr)
    end,
}

lspconfig.pyright.setup(config)

return M
