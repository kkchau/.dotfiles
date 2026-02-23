return {
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            hint = false,
            runtime = {
                version = "LuaJIT",
            }
        }
    },
    filetypes = { "lua" },
}
