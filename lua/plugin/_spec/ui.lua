---@module 'config.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

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
        config = CfgUtil.require('plugin.noice'),
        cond = not in_console(),
    },

    -- Start Greeter
    {
        'goolord/alpha-nvim',
        lazy = false,
        priority = 1000,
        version = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'nvim-lua/plenary.nvim',
        },
        config = CfgUtil.require('plugin.alpha'),
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            {
                'arkav/lualine-lsp-progress',
                version = false,
            },
        },
        config = CfgUtil.require('plugin.lualine'),
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
        config = CfgUtil.require('plugin.bufferline'),
        cond = not in_console(),
    },

    -- Indent Scope
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        version = false,
        dependencies = {
            {
                'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
                version = false,
                config = CfgUtil.require('plugin.rainbow_delimiters'),
            },
        },
        config = CfgUtil.require('plugin.ibl'),
        cond = not in_console(),
    },

    -- File Tree
    {
        'nvim-tree/nvim-tree.lua',
        main = 'nvim-tree',
        event = 'VeryLazy',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        config = CfgUtil.require('plugin.nvim_tree'),
    },

    {
        'folke/edgy.nvim',
        event = 'VeryLazy',
        version = false,
        config = CfgUtil.require('plugin.edgy'),
        cond = not in_console(),
        enabled = false,
    },

    {
        'akinsho/toggleterm.nvim',
        event = 'VeryLazy',
        version = false,
        config = CfgUtil.require('plugin.toggleterm'),
        cond = not in_console(),
    },
}

return UI

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
