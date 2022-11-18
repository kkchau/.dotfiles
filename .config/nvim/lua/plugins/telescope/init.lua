local M = {}
M.__index = M

function M.init()
    local telescope = require("telescope")
    local action_set = require("telescope.actions.set")

    telescope.setup(
        {
            pickers = {
                find_files = {
                    theme = "ivy",
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
                live_grep = {
                    theme = "ivy",
                },
                current_buffer_fuzzy_find = {
                    theme = "ivy",
                },
                buffers = {
                    theme = "ivy",
                }
            },
            defaults = {
                theme = "ivy",
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

    -- remaps
    -- do this globally since I want telescope to top-priority keymaps
    local map_global = require("util").map_global
    map_global("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
    map_global("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
    map_global("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>")
    map_global("n", "<leader>bb", "<cmd>Telescope buffers<CR>")
    map_global("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>")
    map_global("n", "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<CR>")
    map_global("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
end

return M
