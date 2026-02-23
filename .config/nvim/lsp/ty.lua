return {
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
    filetypes = { "python" },
}
