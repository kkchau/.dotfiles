local M = {}
M.__index = M

function M.init()
    vim.cmd([[packadd plenary.nvim]])

    local null_ls = require("null-ls")
    local config = {
        sources = {
            require("null-ls").builtins.formatting.black,
            require("null-ls").builtins.formatting.isort.with(
                {
                    args={"--profile", "black", "-"}
                }
            ),
            require("null-ls").builtins.diagnostics.pylint.with(
                {
                    extra_args={"--init-hook=sys.path.append('src')"}
                }
            ),
        },
        on_attach = function(client, bufnr)
            if client.resolved_capabilities.document_formatting then
                vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
            end
        end
    }
    null_ls.setup(config)

end

return M
