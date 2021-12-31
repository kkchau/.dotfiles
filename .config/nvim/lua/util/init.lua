local M = {}

function M.map(bufnr, type, key, value, opt)
    if opt then
        vim.api.nvim_buf_set_keymap(bufnr, type, key, value, opt)
    else
        vim.api.nvim_buf_set_keymap(
            bufnr,
            type,
            key,
            value,
            { noremap = true, silent = true, expr = false }
        )
    end
end

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
