local M = {}
M.__index = M

function M.init()
    vim.cmd([[packadd plenary.nvim]])
    vim.cmd([[packadd telescope-fzf-native.nvim]])

    local telescope = require("telescope")
    local action_set = require("telescope.actions.set")

    telescope.setup(
        {
            pickers = {
                find_files = {
                    hidden = true,
                    attach_mappings = function(_)
                        action_set.select:enhance({
                            post = function()
                                vim.cmd(":normal! zx")
                            end,
                        })
                        return true
                    end,
                },
            },
            defaults = {
                file_ignore_patterns = {
                    ".git/",
                    "__pycache__",
                    "__snapshots_-",
                    "build/",
                    "node_modules",
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                },
            }
        }
    )

    telescope.load_extension("fzf")

end

return M
