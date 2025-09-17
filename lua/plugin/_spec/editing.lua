---@module 'config.lazy'

local CfgUtil = require('config.util')
local Check = require('user_api.check')

local flag_installed = CfgUtil.flag_installed
local executable = Check.exists.executable
local in_console = Check.in_console

---@type LazySpecs
local Editing = {
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        version = false,
        config = CfgUtil.require('plugin.persistence'),
    },

    {
        'folke/twilight.nvim',
        event = 'VeryLazy',
        version = false,
        config = CfgUtil.require('plugin.twilight'),
        cond = not in_console(),
    },

    --- TODO COMMENTS
    {
        'folke/todo-comments.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-lua/plenary.nvim',
        },
        config = CfgUtil.require('plugin.todo_comments'),
        cond = executable('rg') and not in_console(),
    },
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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
