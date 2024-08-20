local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local vim_exists = Check.exists.vim_exists
local vim_has = Check.exists.vim_has
local in_console = Check.in_console
local is_root = Check.is_root
local luarocks_check = CfgUtil.luarocks_check

---@type (LazySpec)[]
local M = {
    {
        'folke/which-key.nvim',
        main = 'which-key',
        version = false,
        init = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 300
            vim.opt.ttimeout = true
            vim.opt.ttimeoutlen = -1
            CfgUtil.set_tgc()
        end,
        config = source('plugin.which_key'),
        cond = vim_has('nvim-0.9'),
    },
    {
        'dstein64/vim-startuptime',
        lazy = false,
        version = false,
        init = CfgUtil.flag_installed('startuptime'),
        config = source('plugin.startuptime'),
    },
    {
        'vhyrro/luarocks.nvim',
        lazy = false,
        version = false,
        config = source('plugin.luarocks'),
        cond = luarocks_check() and not is_root(),
    },
    {
        'echasnovski/mini.nvim',
        lazy = false,
        version = false,
        config = source('plugin.mini'),
        cond = not in_console(),
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
    },
    {
        'rcarriga/nvim-notify',
        lazy = false,
        main = 'notify',
        version = false,
        dependencies = { 'plenary.nvim' },
        init = CfgUtil.set_tgc(),
        config = source('plugin.notify'),
        cond = not in_console(),
    },
    {
        'lewis6991/hover.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.hover'),
        cond = not in_console(),
    },
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
        version = false,
        config = source('plugin.web_devicons'),
        cond = not in_console(),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
