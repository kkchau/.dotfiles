local M = {}
M.__index = M

function M.init()
    vim.g.oscyank_term = 'tmux'
    local augroups = require("util").nvim_create_augroups
    local autocmds = {
        Yank = {
            {
                "TextYankPost", [[*]],
                "if", "v:event.operator", "is", "'y'",
                [[&&]],
                "v:event.regname", "is", "''",
                [[|]],
                "execute", [['OSCYankReg "']],
                [[|]],
                "endif"
            }
        }
    }
    augroups(autocmds)
end

return M
