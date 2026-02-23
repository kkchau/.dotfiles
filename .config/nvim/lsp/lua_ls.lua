return {
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            }
        }
    },
    filetypes = { "lua" },
}
--vim.lsp.enable('lua_ls')
