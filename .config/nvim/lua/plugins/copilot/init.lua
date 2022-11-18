local M = {}
M.__index = M

function M.init()

    -- Disable tab completion for copilot
    vim.g.copilot_no_tab_map =true

    local map_global = require("util").map_global
    map_global("i", "<C-g>", 'copilot#Accept()', true)
end

return M

