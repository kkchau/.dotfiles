return {
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
                vim.lsp.buf.code_action({
                    context = {
                        only = { "source.fixAll" },
                    },
                    apply = true,
                })
                vim.lsp.buf.format({ async = false })
            end,
        })
    end,
    filetypes = { "python" },
}
