-- disable unused plugins
local disabled_built_ins = {
    "tutor",
    "zipPlugin"
}

-- In order to get the editor to recognize mise tools, prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

require("core.global")
require("core.options").load_options()
require("core.mappings").mappings()
local util = require("util")

-- other autocmds
local main_augroups = require("util").nvim_create_augroups
local main_autocmds = {}
main_augroups(main_autocmds)

-- user commands
vim.api.nvim_create_user_command(
    'Pytest',
    function()
        util.run_in_float(':term pytest -rP --durations=0 ' .. vim.api.nvim_buf_get_name(0))
    end,
    {}
)

vim.api.nvim_create_user_command(
    'PytestFunc',
    function()
        -- Iterate through parents until we get to a function definition
        local cur_node = vim.treesitter.get_node()
        while cur_node:type() ~= 'function_definition' do
            cur_node = cur_node:parent()
            if cur_node == nil then return end
        end

        local function_identifier = vim.treesitter.get_node_text(cur_node:named_child(), 0)
        util.run_in_float(':term pytest -rP -k ' .. function_identifier .. ' ' .. vim.api.nvim_buf_get_name(0))
    end,
    {}
)

vim.api.nvim_create_user_command(
    'ClrOpenInGH',
    function()
        local sha = util.git.get_git_sha():gsub('^%s+', ''):gsub('%s+$', ''):gsub('[\n\r]+', ' ')
        local top_level_path = util.git.show_top_level():gsub('^%s+', ''):gsub('%s+$', ''):gsub('[\n\r]+', ' '):gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
        local file_rel_path = vim.api.nvim_buf_get_name(0):gsub("^" .. top_level_path .. "/", "")
        local url = "https://github.com/color/color/tree/" .. sha .. "/" .. file_rel_path
        print(url)
        os.execute("open " .. url)
    end,
    {}
)

vim.api.nvim_create_user_command(
    'ClrOpenLineInGH',
    function()
        local sha = util.git.get_git_sha():gsub('^%s+', ''):gsub('%s+$', ''):gsub('[\n\r]+', ' ')
        local top_level_path = util.git.show_top_level():gsub('^%s+', ''):gsub('%s+$', ''):gsub('[\n\r]+', ' '):gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
        local file_rel_path = vim.api.nvim_buf_get_name(0):gsub("^" .. top_level_path .. "/", "")
        local line_num = vim.fn.line('.')
        local url = "https://github.com/color/color/tree/" .. sha .. "/" .. file_rel_path .. "#L" .. line_num
        print(url)
        os.execute("open " .. url)
    end,
    {}
)

-- plugins
local lazy = require("lazy-config")
lazy.bootstrap()
lazy.init()
