local M = {}
local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")

local pylsp_config = {
    settings = {
        pylsp = {
            plugins = {
                autopep8 = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                yapf = { enabled = false },
                jedi_completion = {
                    enabled = true,
                    include_class_objects = true,
                    include_function_objects = true,
                    fuzzy = true,
                },
                jedi_definition = {
                    enabled = true,
                    follow_imports = true,
                },
                jedi_hover = { enabled = false },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true },
                mypy = {
                    enabled = true,
                    report_progress = true,
                },
                ruff = {
                    format = { "I" },
                    lineLength = 10000,
                },
                mccabe = { enabled = false },
                preload = { enabled = false },
                pydocstyle = { enabled = false },
            },
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = true
        lsp.on_attach(client, bufnr)
    end,
}

lspconfig.pylsp.setup(pylsp_config)

return M
