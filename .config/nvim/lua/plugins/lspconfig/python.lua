local M = {}
local lspconfig = require("lspconfig")
local lsp = require("plugins.lspconfig")
local configs = require("lspconfig.configs")

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
                -- disable rope
                rope_rename = false,
                mypy = {
                    enabled = false,
                    report_progress = true,
                    live_mode = false,
                    dmypy = true,
                },
                ruff = {
                    enabled = false,
                    format = { "I" },
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

local ruff_config = {
    cmd = { "uvx", "ruff", "server" },
    init_options = {
        settings = {
            args = { 'format' },
            lint = {
                args = { '--fix' }
            }
        }
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                vim.lsp.buf.format()
            end,
        })
        lsp.on_attach(client, bufnr)
    end,
}

local pyright_config = {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "off",
            },
            disableOrganizeImports = true,
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
        lsp.on_attach(client, bufnr)
    end,
}

if not configs.ty then
    configs.ty = {
        default_config = {
            cmd = { "uvx", "ty", "server" },
            filetypes = { "python" },
            root_dir = function(fname)
                return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
            end,
            settings = {
                python = {
                    ty = {
                        disableLanguageServices = true,
                    }
                }
            },
            on_attach = function(client, bufnr)
                client.server_capabilities.definitionProvider = false
                lsp.on_attach(client, bufnr)
            end,

        }
    }
end

--lspconfig.pylsp.setup(pylsp_config)
lspconfig.pyright.setup(pyright_config)
lspconfig.ruff.setup(ruff_config)
lspconfig.ty.setup({})


return M
