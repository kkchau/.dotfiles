vim.pack.add({
    { src = 'https://github.com/folke/snacks.nvim' }
})

vim.api.nvim_set_keymap(
    "n", "<leader>bb", "",
    {
        noremap = true,
        silent = true,
        expr = false,
        callback = function()
            Snacks.picker.buffers()
        end,

    }
)
vim.api.nvim_set_keymap(
    "n", "<leader>ff", "",
    {
        noremap = true,
        silent = true,
        expr = false,
        callback = function()
            Snacks.picker.smart()
        end,

    }
)
vim.api.nvim_set_keymap(
    "n", "<leader>fg", "",
    {
        noremap = true,
        silent = true,
        expr = false,
        callback = function()
            Snacks.picker.grep()
        end,

    }
)
