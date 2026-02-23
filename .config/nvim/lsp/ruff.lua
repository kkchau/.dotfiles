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
                vim.lsp.buf.format()
            end,
        })
    end,
    filetypes = { "python" },
}
