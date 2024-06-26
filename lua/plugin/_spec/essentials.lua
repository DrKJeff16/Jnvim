---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local vim_exists = Check.exists.vim_exists
local vim_has = Check.exists.vim_has
local in_console = Check.in_console
local luarocks_set = CfgUtil.luarocks_set

---@type LazySpec[]
local M = {
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        main = 'which-key',
        version = false,
        init = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 300
            vim.opt.ttimeout = true
            vim.opt.ttimeoutlen = -1
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('plugin.which_key'),
        enabled = vim_has('nvim-0.9'),
    },
    {
        'dstein64/vim-startuptime',
        version = false,
        init = function()
            vim.g.installed_startuptime = 1
        end,
        config = source('plugin.startuptime'),
    },
    {
        'vhyrro/luarocks.nvim',
        lazy = false,
        priority = 1000,
        version = false,
        config = source('plugin.luarocks'),
        enabled = luarocks_set(),
    },
    {
        'vim-scripts/L9',
        lazy = false,
        version = false,
    },
    {
        'echasnovski/mini.nvim',
        version = false,
        config = source('plugin.mini'),
        enabled = not in_console(),
    },
    {
        'tiagovla/scope.nvim',
        version = false,
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.opt.hid = true

            --- NOTE: Required for `scope`
            vim.opt.sessionoptions = {
                'buffers',
                'tabpages',
                'globals',
            }
        end,
        config = source('plugin.scope'),
    },

    {
        'nvim-lua/plenary.nvim',
        lazy = true,
        version = false,
        enabled = not in_console(),
    },

    {
        'rcarriga/nvim-notify',
        main = 'notify',
        version = false,
        dependencies = { 'plenary.nvim' },
        init = function()
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('plugin.notify'),
        enabled = not in_console(),
    },

    {
        'lewis6991/hover.nvim',
        main = 'hover',
        version = false,
        config = source('plugin.hover'),
        enabled = not in_console(),
    },

    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
        version = false,
        enabled = not in_console(),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
