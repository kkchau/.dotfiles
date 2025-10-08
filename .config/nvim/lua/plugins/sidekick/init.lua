local M = {}

function M.init()
    local sidekick = require("sidekick")
    sidekick.setup({
        keys = {
            {
                -- ctrl g
                "<C-g>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<C-g>" -- fallback to normal tab
                    end
                    -- if you are using Neovim's native inline completions
                    -- requires Neovim 0.12+
                    --if vim.lsp.inline_completion.get() then
                    --    return
                    --end
                    return "<C-g>"
                end,
                mode = { "i", "n" },
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            }
        }
    })
end

return M
