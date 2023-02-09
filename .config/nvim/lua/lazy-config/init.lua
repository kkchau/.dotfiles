local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy = nil

local plugin_spec = {

    -- appearance
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.tokyonight_style = "night"
            vim.cmd([[colorscheme tokyonight]])
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("plugins.statusline.lualine")
        end
    },

    -- utility
    { "nvim-treesitter/nvim-treesitter" },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {"nvim-treesitter"},
    },
    {
        "nvim-telescope/telescope.nvim",
        config = require("plugins.telescope").init,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "BurntSushi/ripgrep", lazy = true },
            { "nvim-telescope/telescope-project.nvim", lazy = true },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
    },
    {
        "ojroques/vim-oscyank",
        config = require("plugins.oscyank").init,
    },
    {
        "ellisonleao/glow.nvim",
        config = true,
        cmd = "Glow"
    },

    -- completion
    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        config = require("plugins.cmp").init,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        },
    },
    { -- AI-assisted completion
        "zbirenbaum/copilot-cmp",
        dependencies = {
            { "nvim-cmp" },
            {
                "zbirenbaum/copilot.lua",
                event = "InsertEnter",
                config = function()
                    require("copilot").setup({
                        suggestion = { enabled = false },
                        panel = { enabled = false },
                    })
                end
            }
        },
        config = function ()
          require("copilot_cmp").setup({
              method = "getCompletionsCycling",
          })
        end
    },

    -- lsp
    {
        "neovim/nvim-lspconfig",
        config = require("plugins.lspconfig").init,
        dependencies = {
            {
                "williamboman/mason.nvim",
                config = require("plugins.mason").init
            },
            {
                "williamboman/mason-lspconfig.nvim"
            },
        }
    }
}

local plugins = {}

function plugins.bootstrap()
    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
      })
    end
    vim.opt.rtp:prepend(lazypath)
end

function plugins.init()
    print("Initializing plugins")

    lazy = require("lazy")
    lazy.setup(plugin_spec)
end

return plugins
