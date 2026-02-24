return {
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            hint = false,
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim", "require" },
            },
        }
    },
    filetypes = { "lua" },
}
