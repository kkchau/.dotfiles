-- disable unused plugins
local disabled_built_ins = {
    "tutor",
    "zipPlugin"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

require("core.global")
require("core.options").load_options()
require("core.mappings").mappings()

-- other autocmds
local main_augroups = require("util").nvim_create_augroups
local main_autocmds = {
    FormatOnSave = {
        {
            "BufWritePre */color/**/*.py lua vim.lsp.buf.format()"
        }
    }
}
main_augroups(main_autocmds)

-- user commands
vim.api.nvim_create_user_command('PantsValidate', '!pants lint check %', {})
vim.api.nvim_create_user_command('PantsRepl', ':vs | :term pants repl %', {})
vim.api.nvim_create_user_command('PantsReplhs', ':sp | :term pants repl %', {})
vim.api.nvim_create_user_command('PantsTest', ':vs | :term pants test --test-output=all %', {})
vim.api.nvim_create_user_command('PantsLoopTest', ':vs | :term pants --loop test --test-output=all %', {})
vim.api.nvim_create_user_command('PantsTesths', ':sp | :term pants test --test-output=all %', {})
vim.api.nvim_create_user_command('PantsLoopTesths', ':sp | :term pants --loop test --test-output=all %', {})

-- plugins
local lazy = require("lazy-config")
lazy.bootstrap()
lazy.init()
