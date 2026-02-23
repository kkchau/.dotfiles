-- GitHub Copilot
vim.pack.add({
    'https://github.com/github/copilot.vim'
})
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap(
    "i", "<C-g>", 'copilot#Accept()', { expr = true, noremap = true }
)

-- OpenCode
vim.pack.add({
    'https://github.com/folke/snacks.nvim',
    'https://github.com/nickjvandyke/opencode.nvim'
})
vim.api.nvim_set_keymap(
    "n",
    "<leader>oo",
    "",
    { desc = "Execute opencode action…", callback =     function()
        require("opencode").select()
    end,
 }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>ot",
    "",
    { desc = "Execute opencode action…", callback =     function()
        require("opencode").toggle()
    end,
 }
)
