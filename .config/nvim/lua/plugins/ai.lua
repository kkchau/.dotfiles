-- GitHub Copilot
vim.pack.add({
    'https://github.com/github/copilot.vim'
})
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap(
    "i", "<C-g>", 'copilot#Accept()', { expr = true, noremap = true }
)
-- Sidekick
vim.pack.add({
    'https://github.com/folke/Sidekick.nvim'
})
local sidekick = require("sidekick")
sidekick.setup({
    nes = {
        enabled = true,
        diff = {
            inline = "words",
        },
    },
})

vim.api.nvim_set_keymap("n", "<Tab>", "", {
    expr = true,
    noremap = true,
    silent = true,
    desc = "Goto/Apply Next Edit Suggestion",
    callback = function()
        if not sidekick.nes_jump_or_apply() then
            return "<Tab>"
        end
    end
})

-- OpenCode
vim.pack.add({
    'https://github.com/folke/snacks.nvim',
    'https://github.com/nickjvandyke/opencode.nvim'
})
vim.api.nvim_set_keymap(
    "n",
    "<leader>oo",
    "",
    {
        desc = "Execute opencode action…",
        callback = function()
            require("opencode").select()
        end,
    }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>ot",
    "",
    {
        desc = "Execute opencode action…",
        callback = function()
            require("opencode").toggle()
        end,
    }
)
