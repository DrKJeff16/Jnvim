---@module 'config.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check
local Termux = User.distro.termux

local vim_has = Check.exists.vim_has
local executable = Check.exists.executable
local in_console = Check.in_console

local source = CfgUtil.source
local set_tgc = CfgUtil.set_tgc
local flag_installed = CfgUtil.flag_installed
local luarocks_check = CfgUtil.luarocks_check

---@type LazySpecs
local Essentials = {
    {
        'folke/which-key.nvim',
        main = 'which-key',
        event = 'VeryLazy',
        version = false,
        init = function()
            vim.opt.timeout = true
            vim.opt.ttimeout = true
            vim.opt.timeoutlen = 500
            vim.opt.ttimeoutlen = -1
        end,
        config = source('plugin.which_key'),
        cond = vim_has('nvim-0.10'),
    },
    {
        'dstein64/vim-startuptime',
        lazy = false,
        priority = 1000,
        version = false,
        init = flag_installed('startuptime'),
        config = source('plugin.startuptime'),
    },
    {
        'vhyrro/luarocks.nvim',
        lazy = false,
        version = false,
        init = function()
            set_tgc(true)
        end,
        config = source('plugin.luarocks'),
        cond = luarocks_check() and not Termux:validate(),
    },
    {
        'MunifTanjim/nui.nvim',
        version = false,
    },
    {
        'echasnovski/mini.nvim',
        version = false,
        config = source('plugin.mini'),
        cond = vim_has('nvim-0.10'),
    },
    {
        'tiagovla/scope.nvim',
        lazy = false,
        version = false,
        init = function()
            -- NOTE: Required for `scope`
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
    },
    {
        'rcarriga/nvim-notify',
        lazy = false,
        version = false,
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = source('plugin.notify'),
        cond = not in_console(),
    },
    -- Project Manager
    {
        'DrKJeff16/project.nvim',
        dev = true,
        main = 'project_nvim',
        lazy = false,
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = source('plugin.project'),
    },
    {
        'nvim-tree/nvim-web-devicons',
        version = false,
        config = source('plugin.web_devicons'),
        cond = not in_console(),
    },
    {
        'gennaro-tedesco/nvim-possession',
        lazy = false,
        version = false,
        dependencies = { 'ibhagwan/fzf-lua' },
        config = source('plugin.possession'),
    },
    {
        'ibhagwan/fzf-lua',
        lazy = true,
        version = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = source('plugin.fzf.fzf_lua'),
        cond = executable('fzf'),
    },
}

return Essentials

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
