local M = {}

function M.init()
    local sidekick = require("sidekick")
    sidekick.setup({})

    vim.keymap.set(
        "n",
        "<C-g>",
        function()
            -- if there is a next edit, jump to it, otherwise apply it if any
            if not sidekick.nes_jump_or_apply() then
                return -- jumped or applied
            end
            -- if you are using Neovim's native inline completions
            -- requires Neovim 0.12+
            --if vim.lsp.inline_completion.get() then
            --    return
            --end
            return "<C-g>"
        end,
        { noremap = true, silent = true, buffer = true, }
    )
end

return M
