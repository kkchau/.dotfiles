-- disable unused plugins
local disabled_built_ins = {
    "tutor",
    "zipPlugin"
}
for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 0
end

require("core.options")
require("core.mappings")
require("core.diagnostics")

require("commands")
require("plugins")

-- LSP
local language_servers = {
    'bashls',
    'gopls',
    'groovyls',
    'html',
    'lua_ls',
    'pyright',
    'ruff',
    'rust_analyzer',
    'sqls',
    'terraformls',
    'ts_ls',
    'ty',
}
for _, server in ipairs(language_servers) do
    vim.lsp.enable(server)
end
