local map = require("util").map
local M = {}

function M.init()
    vim.opt.conceallevel = 1
    require("obsidian").setup({
        workspaces = {
            -- On different systems with potentially different workspace paths,
            -- one entry per workspace is needed
            {
                name = "Personal",
                path = "~/Documents/obsidian_vault",
            },
        },
        templates = {
            folder = "Templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
        },
        legacy_commands = false,
        opts = {}
    })

    -- Keymaps specific for markdown files when Obsidian is loaded
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            map(0, "n", "<leader>oo", "<cmd>Obsidian open<CR>")
            map(0, "n", "<leader>on", "<cmd>Obsidian new<CR>")
            map(0, "n", "<leader>ot", "<cmd>Obsidian new_from_template<CR>")
            map(0, "n", "<leader>ob", "<cmd>Obsidian backlinks<CR>")
            map(0, "n", "gd", "<cmd>Obsidian follow_link<CR>")
        end,
    })
end

return M
