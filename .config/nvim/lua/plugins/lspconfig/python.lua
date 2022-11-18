local M = {}
local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")

local pylsp_config = {
    settings = {
        pylsp = {
            cmd = { "pylsp", "--verbose" },
            plugins = {
                autopep8 = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                yapf = { enabled = false },
                jedi_completion = {
                    enabled = false,
                    include_class_objects = true,
                    include_function_objects = true,
                    fuzzy = true,
                },
                jedi_definition = {
                    enabled = false,
                    follow_imports = true,
                },
                jedi_hover = { enabled = false },
                jedi_references = { enabled = false },
                jedi_signature_help = { enabled = false },
                jedi_symbols = { enabled = false },
                mypy = {
                    enabled = false,
                    report_progress = true,
                    live_mode = false,
                    dmypy = true,
                },
                ruff = {
                    enabled = true,
                    format = { "I" },
                    lineLength = 10000,
                    preview = true,
                },
                mccabe = { enabled = false },
                preload = { enabled = false },
                pydocstyle = { enabled = false },
            },
        },
        filetypes = {
            "py",
            "pants",
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = true
        lsp.on_attach(client, bufnr)
    end,
}

lspconfig.pylsp.setup(pylsp_config)
lspconfig.pyright.setup({})

return M
