local M = {}

vim.lsp.config(
    'nextflow_ls',
    {
        cmd = { "java", "-jar", "/usr/local/bin/nextflow-language-server-all.jar" },
    }
)
vim.lsp.enable('nextflow_ls')

return M
