local M = {}
M.__index = M

function M.init()

    -- Disable tab completion for copilot
    vim.g.copilot_no_tab_map =true

    local map_global = require("util").map_global
    map_global("i", "<C-g>", 'copilot#Accept()', true)

    vim.g.copilot_filetypes = {
        bash = true,
        javascript = true,
        lua = true,
        python = true,
        rust = true,
        typescript = true,
        yaml = true,
    }
end

return M

