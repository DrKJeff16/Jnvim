---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console
local is_nil = Check.value.is_nil

---@type (LazySpec)[]
local M = {
    --- Statusline
    {
        'nvim-lualine/lualine.nvim',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.opt.showmode = false
        end,
        config = source('plugin.lualine'),
        cond = not is_nil(use_statusline) and (use_statusline == 'lualine') or false,
    },
    {
        'glepnir/galaxyline.nvim',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.opt.showmode = false
            vim.opt.termguicolors = not in_console()
        end,
        config = source('plugin.galaxyline'),
        cond = not is_nil(use_statusline) and (use_statusline == 'galaxyline') or true,
    },
    --- Tabline
    {
        'akinsho/bufferline.nvim',
        version = false,
        dependencies = {
            'nvim-web-devicons',
            'scope.nvim',
        },
        init = function()
            vim.opt.stal = 2
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('plugin.bufferline'),
        cond = not in_console(),
    },
    --- Tabline
    {
        'romgrk/barbar.nvim',
        version = false,
        dependencies = {
            'nvim-web-devicons',
            'scope.nvim',
        },
        init = function()
            vim.opt.stal = 2
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('plugin.barbar'),
        -- cond = not in_console(),
        enabled = false,
    },
    --- Indent Scope
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        version = false,
        config = source('plugin.blank_line'),
        cond = not in_console(),
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        version = false,
        config = source('plugin.rainbow_delimiters'),
        cond = not in_console(),
    },
    --- File Tree
    {
        'nvim-tree/nvim-tree.lua',
        main = 'nvim-tree',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        init = function()
            --- Disable `netrw`.
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('plugin.nvim_tree'),
        cond = not in_console(),
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        version = false,
        dependencies = {
            'plenary.nvim',
            'nvim-web-devicons',
            'MunifTanjim/nui.nvim',
            -- '3rd/image.nvim',
        },
        init = function()
            --- Disable `netrw`.
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
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
    },
    {
        'brenoprata10/nvim-highlight-colors',
        main = 'nvim-highlight-colors',
        version = false,
        init = function()
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('plugin.hicolors'),
        cond = vim_exists('+termguicolors'),
    },
    {
        'akinsho/toggleterm.nvim',
        version = false,
        config = source('plugin.toggleterm'),
        cond = not in_console(),
    },
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'MunifTanjim/nui.nvim',
            'nvim-notify',
            'mini.nvim',
        },
        config = source('plugin.noice'),
        cond = not in_console(),
    },
    {
        'LudoPinelli/comment-box.nvim',
        version = false,
        config = source('plugin.commentbox'),
        enabled = false,
    },
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        version = false,
        dependencies = { 'nvim-web-devicons' },
        config = source('plugin.dashboard'),
        enabled = false,
    },
    {
        'startup-nvim/startup.nvim',
        event = 'VimEnter',
        version = false,
        dependencies = { 'plenary.nvim' },
        config = source('plugin.startup'),
        enabled = false,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
