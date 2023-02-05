local execute = vim.api.nvim_command
local global = require("core.global")
local packer_compiled = global.data_path .. "packer_compiled.vim"
local compile_to_lua = global.data_path .. "lua" .. global.path_sep .. "_compiled.lua"

local packer = nil

local function init()

    -- initialize packer
    packer = require("packer")
    packer.init(
        {
            compile_path = packer_compiled,
            disable_commands = true,
            display = {
                open_fn = require("packer.util").float,
            },
            git = { clone_timeout = 120 }
        }
    )
    packer.reset()

    -- plugins
    -- style
    packer.use(
        {
            "folke/tokyonight.nvim",
            commit = "affb21a81e6d7de073378eb86d02864c594104d9",
            config = function()
                vim.g.tokyonight_style = "night"
                vim.cmd([[colorscheme tokyonight]])
            end,
        }
    )   -- tokyonight theme
    packer.use(
        {
            "nvim-lualine/lualine.nvim",
            commit = "0050b308552e45f7128f399886c86afefc3eb988",
            config = function()
                require("plugins.statusline.lualine")
            end
        }
    )   -- lualine statusline

    -- usability
    packer.use({
        "ojroques/vim-oscyank",
        commit = "e6298736a7835bcb365dd45a8e8bfe86d935c1f8",
        config = require("plugins.oscyank").init,
    })
    packer.use({
        "nvim-treesitter/nvim-treesitter",
        config = require("plugins.treesitter").init

    })
    packer.use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter"
    })
    packer.use({
        "nvim-telescope/telescope.nvim",
        config = require("plugins.telescope").init,
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "BurntSushi/ripgrep", opt = true },
            { "nvim-telescope/telescope-project.nvim", opt = true },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                opt = true,
                run = "make",
            },
        },
    })

    -- completion
    packer.use(
        {
            "github/copilot.vim",
        }
    )
    -- packer.use(
    --     {
    --         "Exafunction/codeium.vim",
    --         commit = "60f2bef098299ede079638eaad645faf87737a3a",
    --     }
    -- ) -- AI-code completion
    packer.use({ -- Autocompletion
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        },
        config = require("plugins.nvim-cmp").init,
    })

    -- git
    packer.use({ 'tpope/vim-fugitive' })
    packer.use({ 'lewis6991/gitsigns.nvim' })

    -- lsp
    packer.use(
        {
            "neovim/nvim-lspconfig",
            config = require("plugins.lspconfig").init,
            requires = {
                { "williamboman/mason.nvim" },
                { "williamboman/mason-lspconfig.nvim" },
            },
            commit = "01185a87523b7054038dd60f0524ea3a8e1c6885",
        }
    )   -- lspconfig
    packer.use({
        'williamboman/mason.nvim',
        config = require("plugins.mason").init,
    }) -- auto-config LSP servers
    packer.use({
        "jose-elias-alvarez/null-ls.nvim",
        config = require("plugins.null-ls").init,
        requires = "nvim-lua/plenary.nvim"
    }) --null-ls for non-LSP

end

local plugins = setmetatable({}, {
    __index = function(_, key)
        if not packer then
            init()
        end
        return packer[key]
    end,
})


-- Bootstrap Packer and the Plugins + loads configs afterwards
function plugins.bootstrap()
    local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
      -- check if packer exists or is installed
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        -- fetch packer
        execute(
            "!git clone https://github.com/wbthomason/packer.nvim " .. install_path
        )
        execute("packadd packer.nvim")

        -- load packer plugins
        init()

        -- install packer plugins
        require("packer").sync()
    else
        -- add packer and load plugins and config
        execute("packadd packer.nvim")
        init()
    end
end

-- converts the compiled file to lua
function plugins.convert_compile_file()
    local lines = {}
    local lnum = 1
    lines[#lines + 1] = "vim.cmd [[packadd packer.nvim]]\n"
    for line in io.lines(packer_compiled) do
        lnum = lnum + 1
        if lnum > 15 then
            lines[#lines + 1] = line .. "\n"
            if line == "END" then
                break
            end
        end
    end
    table.remove(lines, #lines)
    if vim.fn.isdirectory(global.data_path .. "lua") ~= 1 then
        os.execute("mkdir -p " .. global.data_path .. "lua")
    end
    if vim.fn.filereadable(compile_to_lua) == 1 then
        os.remove(compile_to_lua)
    end
    local file = io.open(compile_to_lua, "w")
    for _, line in ipairs(lines) do
        file:write(line)
    end
    file:close()

    os.remove(packer_compiled)
end

-- autocompile function called by autocmd on packer complete
function plugins.auto_compile()
    plugins.compile()
    plugins.convert_compile_file()
end

-- loads the compiled packer file and sets the commands for packer
function plugins.load_compile()
    if vim.fn.filereadable(compile_to_lua) == 1 then
        require("_compiled")
    else
        assert(
            "Missing packer compile file Run PackerCompile Or PackerInstall to fix"
        )
    end

    vim.cmd(
        [[command! PackerCompile lua require('packer-config').auto_compile()]]
    )
    vim.cmd([[command! PackerInstall lua require('packer-config').install()]])
    vim.cmd([[command! PackerUpdate lua require('packer-config').update()]])
    vim.cmd([[command! PackerSync lua require('packer-config').sync()]])
    vim.cmd([[command! PackerClean lua require('packer-config').clean()]])
    vim.cmd([[command! PackerStatus    lua require('packer-config').status()]])

    -- autocompile event
    vim.cmd(
        [[autocmd User PackerComplete lua require('packer-config').auto_compile()]]
    )
end

return plugins
