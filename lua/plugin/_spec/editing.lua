---@module 'lazy'

local CfgUtil = require('config.util')
local Check = require('user_api.check')

local in_console = Check.in_console

---@type LazySpec[]
local Editing = {
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        version = false,
        config = CfgUtil.require('plugin.persistence'),
    },

    {
        'folke/twilight.nvim',
        version = false,
        config = CfgUtil.require('plugin.twilight'),
        cond = not in_console(),
    },

    --- TODO COMMENTS
    { import = 'plugin.todo_comments' },
    { import = 'plugin.a_vim' },
    {
        'folke/zen-mode.nvim',
        event = 'VeryLazy',
        version = false,
        config = CfgUtil.require('plugin.zen_mode'),
        cond = not in_console(),
    },
    {
        'julienvincent/nvim-paredit',
        version = false,
        config = CfgUtil.require('plugin.paredit'),
    },
}

return Editing

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
