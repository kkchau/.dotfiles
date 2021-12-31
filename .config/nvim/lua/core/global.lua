local global = {}
local path_sep = package.config:sub(1, 1)

function global:load_vars()
    self.path_sep = path_sep
    self.vim_path = vim.fn.stdpath("config")
    self.lsp_path = vim.fn.stdpath("data") .. path_sep .. "lsp"
    self.data_path = string.format(
        vim.fn.stdpath("data") .. path_sep .. "site" .. path_sep
    )
end

global:load_vars()

return global
