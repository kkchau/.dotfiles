require("core.global")
require("core.options").load_options()
require("core.mappings").mappings()

-- plugins
local pack = require("packer-config")
pack.bootstrap()
pack.load_compile()
