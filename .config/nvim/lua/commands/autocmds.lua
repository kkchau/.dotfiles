vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function(event)
        vim.opt.relativenumber = false
        vim.opt.number = true
    end
})
vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function(event)
        vim.opt.relativenumber = true
        vim.opt.number = false
    end
})
