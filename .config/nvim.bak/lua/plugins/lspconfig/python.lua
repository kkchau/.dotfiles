local M = {}

vim.lsp.config(
    'ruff',
    {
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
        end,
    }
)

vim.lsp.config(
    'pyright',
    {
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
        end,
    }
)

vim.lsp.config(
    'ty',
    {
        cmd = { "uvx", "ty", "server" },
        root_dir = vim.fs.dirname(vim.fs.find('.git', { path = vim.fn.expand('%:p'), upward = true })[1]) or
            vim.loop.os_homedir(),
        settings = {
            python = {
                ty = {
                    disableLanguageServices = true,
                }
            }
        },
        on_attach = function(client, bufnr)
            client.server_capabilities.definitionProvider = false
        end,
    }
)

vim.lsp.enable('pyright')
vim.lsp.enable('ruff')
vim.lsp.enable('ty')

return M
