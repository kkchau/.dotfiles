-- Global key maps

-- Split navigation
local default_keymap_opts = { noremap = true, silent = true, expr = false }
vim.api.nvim_set_keymap("n", "<C-H>", "<C-W>h", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<C-J>", "<C-W>j", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<C-K>", "<C-W>k", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<C-L>", "<C-W>l", default_keymap_opts)

-- Buffer management
vim.api.nvim_set_keymap("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", default_keymap_opts)

-- Utilities
-- Copy filepath to clipboard
vim.api.nvim_set_keymap("n", "<leader>yp", "",
    {
        callback = function()
            vim.fn.setreg('+', vim.fn.expand('%'))
        end
    }
)

-- LSP
vim.api.nvim_set_keymap("n", "gd", "", {
    noremap = true,
    silent = true,
    expr = false,
    callback = function()
        vim.lsp.buf.definition()
    end
})
vim.api.nvim_set_keymap("n", "gr", "", {
    noremap = true,
    silent = true,
    expr = false,
    callback = function()
        vim.lsp.buf.references()
    end
})
