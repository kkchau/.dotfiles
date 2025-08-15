local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")

local config = {
    on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
    end,
}

lspconfig.gopls.setup(config)
