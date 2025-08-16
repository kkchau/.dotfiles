local M = {}
M.__index = M

function M.init()
    local codecompanion = require("codecompanion")
    codecompanion.setup({
        --[[
        strategies = {
            chat = {
                adapter = {
                    name = "ollama",
                    model = "qwen3:8b",
                },
            },
            cmd = {
                adapter = "copilot",
            },
            inline = {
                adapter = "copilot",
            },
        }
        ]]
    })
end

return M
