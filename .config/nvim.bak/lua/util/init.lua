local M = { git = require('util.git') }

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

function M.open_default_float()
    local gheight = vim.api.nvim_list_uis()[1].height
    local gwidth = vim.api.nvim_list_uis()[1].width
    local width = math.floor(gwidth * 0.9)
    local height = math.floor(gheight * 0.9)
    vim.api.nvim_open_win(
        vim.api.nvim_create_buf(false, true),
        true,
        {
            relative = "editor",
            width = width,
            height = height,
            row = (gheight - height) * 0.5,
            col = (gwidth - width) * 0.5,
        }
    )
end

function M.run_in_float(cmd)
    M.open_default_float()
    print(cmd)
    vim.cmd(cmd)
end

return M
