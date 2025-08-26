---@module 'config.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local vim_has = Check.exists.vim_has
local executable = Check.exists.executable
local in_console = Check.in_console

local flag_installed = CfgUtil.flag_installed

---@type LazySpecs
local Essentials = {
    {
        'folke/which-key.nvim',
        main = 'which-key',
        event = 'VeryLazy',
        version = false,
        init = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 500
        end,
        config = CfgUtil.require('plugin.which_key'),
        cond = vim_has('nvim-0.10'),
    },
    {
        'dstein64/vim-startuptime',
        priority = 1000,
        version = false,
        init = flag_installed('startuptime'),
        config = CfgUtil.require('plugin.startuptime'),
    },
    {
        'MunifTanjim/nui.nvim',
        version = false,
    },
    {
        'echasnovski/mini.nvim',
        version = false,
        config = CfgUtil.require('plugin.mini'),
    },
    {
        'tiagovla/scope.nvim',
        version = false,
        init = function()
            -- NOTE: Required for `scope`
            vim.opt.sessionoptions = {
                'buffers',
                'tabpages',
                'globals',
            }
        end,
        config = CfgUtil.require('plugin.scope'),
    },
    {
        'nvim-lua/plenary.nvim',
        lazy = true,
        version = false,
    },
    {
        'rcarriga/nvim-notify',
        version = false,
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = CfgUtil.require('plugin.notify'),
        cond = not in_console(),
    },
    -- Project Manager
    {
        'DrKJeff16/project.nvim',
        dev = true,
        event = 'VeryLazy',
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = CfgUtil.require('plugin.project'),
    },
    {
        'nvim-tree/nvim-web-devicons',
        version = false,
        config = CfgUtil.require('plugin.web_devicons'),
        cond = not in_console(),
    },
    {
        'gennaro-tedesco/nvim-possession',
        version = false,
        dependencies = {
            {
                'ibhagwan/fzf-lua',
                lazy = true,
                version = false,
                dependencies = { 'nvim-tree/nvim-web-devicons' },
                config = CfgUtil.require('plugin.fzf.fzf_lua'),
                cond = executable('fzf'),
            },
        },
        config = CfgUtil.require('plugin.possession'),
    },
}

return Essentials

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
