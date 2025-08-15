local util = require("util")
local M = {}

function M.mappings()
    -- Split navigation
    util.map_global("n", "<C-H>", "<C-W>h")
    util.map_global("n", "<C-J>", "<C-W>j")
    util.map_global("n", "<C-K>", "<C-W>k")
    util.map_global("n", "<C-L>", "<C-W>l")

    -- Buffers
    util.map_global("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>")

    -- Symbols
    -- Builtin: <leader>ds vim.lsp.buf.document_symbol in float

    -- Copy filepath to clipboard
    vim.api.nvim_set_keymap("n", "<leader>yp", "",
        {
            callback = function()
                vim.fn.setreg('+', vim.fn.expand('%'))
            end
        }
    )
end

return M
