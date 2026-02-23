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
vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end, { desc = "Execute opencode action…" })
