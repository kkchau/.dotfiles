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
        legacy_commands = false,
    })
end

return M
