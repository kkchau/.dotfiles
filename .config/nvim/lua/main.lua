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

-- plugins
local lazy = require("lazy-config")
lazy.bootstrap()
lazy.init()
