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
            vim.cmd([[colorscheme tokyonight-night]])
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("plugins.statusline.lualine")
        end
    },
    {
        'linrongbin16/lsp-progress.nvim',
        config = function()
            require('lsp-progress').setup()
        end
    },
    { "LukeGoodsell/nextflow-vim" },

    -- utility
    {
        "nvim-treesitter/nvim-treesitter",
        config = require("plugins.treesitter").init,
        lazy = false,
    },
    {
        "ggandor/leap.nvim",
        config = require("plugins.leap").init,
        lazy = false,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = require("plugins.treesitter").init,
        lazy = false,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter" },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter" },
    },
    {
        "nvim-telescope/telescope.nvim",
        config = require("plugins.telescope").init,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "BurntSushi/ripgrep",                    lazy = true },
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
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },

    -- git
    { "tpope/vim-fugitive" },

    -- AI
    {
        "github/copilot.vim",
        config = require("plugins.copilot").init,
    },
    {
      "olimorris/codecompanion.nvim",
      config = require("plugins.codecompanion").init,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        config = require("plugins.cmp").init,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
        },
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
    },
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
