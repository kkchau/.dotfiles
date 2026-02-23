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
