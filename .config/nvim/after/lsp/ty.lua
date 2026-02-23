return {
    cmd = { "uvx", "ty", "server" },
    root_dir = vim.fs.dirname(
        vim.fs.find('.git', { path = vim.fn.expand('%:p'), upward = true })[1]
    ) or vim.loop.os_homedir(),
    filetypes = { "python" },
}
