---@module 'user_api.types.lazy'

local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')

local source = CfgUtil.source
local set_tgc = CfgUtil.set_tgc
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type (LazySpec)[]
local UI = {
    --- Statusline
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        version = false,
        dependencies = { 'nvim-web-devicons' },
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.opt.showmode = false
            set_tgc()
        end,
        config = source('plugin.lualine'),
        cond = not in_console(),
    },
    --- Tabline
    {
        'akinsho/bufferline.nvim',
        lazy = false,
        version = false,
        dependencies = {
            'nvim-web-devicons',
            'scope.nvim',
        },
        init = function()
            vim.opt.stal = 2
            set_tgc()
        end,
        config = source('plugin.bufferline'),
        cond = not in_console(),
    },
    --- Indent Scope
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.blank_line'),
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.rainbow_delimiters'),
    },
    --- File Tree
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

            set_tgc()
        end,
        config = source('plugin.nvim_tree'),
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        version = false,
        dependencies = {
            'plenary.nvim',
            'nvim-web-devicons',
            'MunifTanjim/nui.nvim',
            '3rd/image.nvim',
        },
        init = function()
            --- Disable `netrw`
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            set_tgc()
        end,
        config = source('plugin.neo_tree'),
        cond = not in_console(),
        enabled = false,
    },
    {
        'nvim-zh/colorful-winsep.nvim',
        event = 'WinNew',
        version = false,
        config = source('plugin.colorful_winsep'),
        cond = not in_console(),
        enabled = false,
    },
    {
        'brenoprata10/nvim-highlight-colors',
        main = 'nvim-highlight-colors',
        version = false,
        init = set_tgc,
        config = source('plugin.hicolors'),
        cond = vim_exists('+termguicolors'),
    },
    {
        'akinsho/toggleterm.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.toggleterm'),
        cond = not in_console(),
    },
    {
        'folke/noice.nvim',
        lazy = false,
        version = false,
        dependencies = {
            'MunifTanjim/nui.nvim',
            'nvim-notify',
            'mini.nvim',
        },
        config = source('plugin.noice'),
        cond = not in_console(),
    },
}

return UI

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
