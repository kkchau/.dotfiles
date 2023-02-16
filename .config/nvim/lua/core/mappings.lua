local remap = require("util").map_global
local M = {}

function M.mappings()

    -- Split navigation
    remap("n", "<C-H>", "<C-W>h")
    remap("n", "<C-J>", "<C-W>j")
    remap("n", "<C-K>", "<C-W>k")
    remap("n", "<C-L>", "<C-W>l")

    -- Buffers
    remap("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>")

end

return M
