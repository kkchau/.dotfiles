local map = require("util").map_global
local M = {}

function M.init()
    local codecompanion = require("codecompanion")
    codecompanion.setup({
        interactions = {
            chat = {
                adapter = {
                    name = "cursor",
                },
            },
            cmd = {
                adapter = "copilot",
            },
            inline = {
                adapter = "copilot",
            },
        }
    })

    map('n', '<leader>cc', '<cmd>CodeCompanionChat Toggle<CR>')
end

return M
