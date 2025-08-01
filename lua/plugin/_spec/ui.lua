---@module 'config.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local source = CfgUtil.source
local in_console = Check.in_console

---@type LazySpecs
local UI = {
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
            'echasnovski/mini.nvim',
        },
        config = source('plugin.noice'),
        cond = not in_console(),
    },

    -- Start Greeter
    {
        'goolord/alpha-nvim',
        lazy = false,
        version = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'nvim-lua/plenary.nvim',
        },
        config = source('plugin.alpha'),
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.opt.showmode = false
        end,
        config = source('plugin.lualine'),
        cond = not in_console(),
    },

    -- Tabline
    {
        'akinsho/bufferline.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'tiagovla/scope.nvim',
        },
        init = function()
            vim.opt.stal = 2
        end,
        config = source('plugin.bufferline'),
        cond = not in_console(),
    },

    -- Indent Scope
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        version = false,
        config = source('plugin.ibl'),
        cond = not in_console(),
    },

    -- File Tree
    {
        'nvim-tree/nvim-tree.lua',
        main = 'nvim-tree',
        event = 'VeryLazy',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        init = function()
            --- Disable `netrw`
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        config = source('plugin.nvim_tree'),
    },

    {
        'akinsho/toggleterm.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.toggleterm'),
        cond = not in_console(),
    },
}

return UI

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
