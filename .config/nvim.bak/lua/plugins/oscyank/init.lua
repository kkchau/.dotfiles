local M = {}

function M.init()
    vim.g.oscyank_term = 'tmux'
    vim.api.nvim_create_autocmd(
        "TextYankPost",
        {
            group = vim.api.nvim_create_augroup('Yank', {}),
            pattern = "*",
            callback = function(event)
                if event.operator == 'y' and event.regname == '' then
                    vim.cmd('OSCYankRegister ""')
                end
            end
        }
    )
end

return M
