local M = {}
M.__index = M

function M.init()

    -- Disable Codeium by default
    vim.g.codeium_enabled = false

    -- keymaps
    local map_global = require("util").map_global
    map_global("i", "<C-g>", 'codeium#Accept()', true)
    map_global("i", "<C-x>", 'codeium#Clear()', true)

end

return M
