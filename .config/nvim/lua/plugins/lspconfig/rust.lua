local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")
local augroups_lsp_rust = require("util").nvim_create_augroups

local config = {
    on_attach = function(client, bufnr)
        if client.resolved_capabilities.document_formatting then
            local autocmds = {
                Format = {
                    {
                        "BufWritePre",
                        "<buffer>",
                        "lua vim.lsp.buf.formatting_sync()",
                    },
                },
            }
            augroups_lsp_rust(autocmds)
        end
        lsp.on_attach(client, bufnr)
    end,
}

lspconfig.rust_analyzer.setup(config)
