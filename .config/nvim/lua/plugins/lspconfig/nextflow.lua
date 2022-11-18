local M = {}
local lspconfig = require("lspconfig")

lspconfig.nextflow_ls.setup(
    {
        cmd = { "java", "-jar", "/usr/local/bin/nextflow-language-server-all.jar" },
    }
)

return M
