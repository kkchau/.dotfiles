local M = {}

function M.map_global(type, key, value, expr)
    vim.api.nvim_set_keymap(
        type,
        key,
        value,
        {
            noremap = true,
            silent = true,
            expr = expr
        }
    )

end

return M
