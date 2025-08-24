local map = require("util").map
local LSP = {}

function LSP.init()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            -- Enable completion by <C-X><C-O>
            vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
            map(event.buf, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
            map(event.buf, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
            map(event.buf, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
            map(event.buf, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
            map(event.buf, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
            map(event.buf, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
            map(event.buf, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
            map(event.buf, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
            map(event.buf, 'n', '<C-e>', '<cmd>lua vim.diagnostic.open_float()<CR>')
            map(event.buf, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
            map(event.buf, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
            map(event.buf, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
            map(event.buf, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>')

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

    local servers = {
        "bash",
        "go",
        "html",
        "lua",
        "nextflow",
        "python",
        "rust",
        "sql",
        "terraform",
        "typescript",
    }
    -- load lsp configs for languages
    for _, server in ipairs(servers) do
        local settings = { lsp_config = "plugins.lspconfig." .. server }
        require(settings.lsp_config)
    end
end

return LSP
