local M = {}

function M.init()
    require("snacks").setup({
        dim = { enabled = true },
        image = {
            enabled = true,
            resolve = function(path, src)
                if require("obsidian.api").path_is_note(path) then
                    return require("obsidian.api").resolve_image_path(src)
                end
            end,
        },
    })
end

return M
