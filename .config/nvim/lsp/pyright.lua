return {
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
        --client.server_capabilities.hoverProvider = false
    end,
    filetypes = { "python" },
}
