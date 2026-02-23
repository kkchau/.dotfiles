local git = {}

function git.get_git_sha()
    local exc = assert(io.popen("git rev-parse HEAD", 'r'))
    local sha = assert(exc:read("*a"))
    exc:close()
    return sha
end

function git.show_top_level()
    local exc = assert(io.popen("git rev-parse --show-toplevel", 'r'))
    local path = assert(exc:read("*a"))
    return path
end

return git
