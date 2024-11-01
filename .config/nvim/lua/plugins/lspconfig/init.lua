local map = require("util").map
local LSP = {}
LSP.__index = LSP

function LSP.on_attach(client, bufnr)

    -- Enable completion by <C-X><C-O>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    map(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    map(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    map(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    map(bufnr, 'n', '<C-e>', '<cmd>lua vim.diagnostic.open_float()<CR>')
    map(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    map(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    map(bufnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
    map(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

end

function LSP.init()
    local servers = {
        "bash",
        "go",
        "lua",
        "python",
        "rust",
    }
    -- load lsp configs for languages
    for _, server in ipairs(servers) do
        local settings = { lsp_config = "plugins.lspconfig." .. server }
        require(settings.lsp_config)
    end
end

return LSP
