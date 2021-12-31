local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")
--local capabilities = require("plugins.lspconfig.capabilities").capabilities

local config = {
    settings = lspconfig.pyright.settings,
    flags = { debounce_text_changes = 500 },
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        lsp.on_attach(client, bufnr)
    end,
}

local M = {}

lspconfig.pyright.setup(config)

return M
