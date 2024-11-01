local M = {}
local lspconfig = require("lspconfig")
local lsp = require('plugins.lspconfig')
local config = {
    on_attach = lsp.on_attach,
}
lspconfig.gopls.setup(config)
return M
