vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig'
})
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = event.buf,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end
            })
        end
    end
})

vim.pack.add({
    'https://github.com/williamboman/mason.nvim'
})
require('mason').setup({
    ensure_installed = {
        'bashls',
        'gopls',
        'groovyls',
        'html',
        'lua-language-server',
        'pyright',
        'ruff',
        'rust_analyzer',
        'sqls',
        'terraformls',
        'ts_ls'
    },
    automatic_installation = true
})
