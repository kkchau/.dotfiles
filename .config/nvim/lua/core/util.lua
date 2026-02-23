local M = {}

function M.get_git_sha()
    local exc = assert(io.popen("git rev-parse HEAD", 'r'))
    local sha = assert(exc:read("*a"))
    exc:close()
    return sha
end

function M.git_show_top_level()
    local exc = assert(io.popen("git rev-parse --show-toplevel", 'r'))
    local path = assert(exc:read("*a"))
    return path
end

function M.open_default_float()
    local gheight = vim.api.nvim_list_uis()[1].height
    local gwidth = vim.api.nvim_list_uis()[1].width
    local width = math.floor(gwidth * 0.9)
    local height = math.floor(gheight * 0.9)
    vim.api.nvim_open_win(
        vim.api.nvim_create_buf(false, true),
        true,
        {
            relative = "editor",
            width = width,
            height = height,
            row = (gheight - height) * 0.5,
            col = (gwidth - width) * 0.5,
        }
    )
end

function M.run_in_float(cmd)
    M.open_default_float()
    print(cmd)
    vim.cmd(cmd)
end

return M
