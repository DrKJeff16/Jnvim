---@module 'lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local in_console = Check.in_console

---@type LazySpec[]
local Essentials = {
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
            vim.o.sessionoptions = 'buffers,tabpages,globals'
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
            { 'ibhagwan/fzf-lua' },
        },
        config = CfgUtil.require('plugin.possession'),
    },
}

return Essentials

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
