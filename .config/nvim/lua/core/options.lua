local M = {}

function M.load_options()
    -- columns
    vim.opt.cursorcolumn = true
    vim.opt.colorcolumn = '80'
    vim.opt.number = true
    vim.opt.signcolumn = "auto"
    vim.opt.wrap = false

    -- indent
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 4
    vim.opt.autoindent = true
    vim.opt.smartindent = true

    -- splits
    vim.opt.splitbelow = true
    vim.opt.splitright = true

    -- usage
    vim.opt.wildmenu = true
    vim.opt.clipboard = "unnamedplus"

    -- search
    vim.opt.smartcase = true
    vim.opt.hlsearch = false

    -- optimize
    vim.opt.lazyredraw = true

    -- index folders for find command
    vim.opt.path = "**/*"
    vim.opt.wildignore:append(
        {
	    ".git/",
	    "build",
	    "coverage",
	    "dist",
        }
    )

end

return M
