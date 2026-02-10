local M = {}

function M.init()
    local sidekick = require("sidekick")

    sidekick.setup({
        cli = {
            mux = {
                backend = "tmux",
                enabled = true,
            },
        },
        nes = {
            enabled = true,
            diff = {
                inline = "words",
            },
        },
    })

    vim.keymap.set("n", "<Tab>", function()
        if not sidekick.nes_jump_or_apply() then
            return "<Tab>"
        end
    end, {
        expr = true,
        noremap = true,
        silent = true,
        desc = "Goto/Apply Next Edit Suggestion",
    })
end

return M
