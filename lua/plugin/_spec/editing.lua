---@module 'config.lazy'

local CfgUtil = require('config.util')
local Check = require('user_api.check')

local source = CfgUtil.source
local flag_installed = CfgUtil.flag_installed
local executable = Check.exists.executable
local in_console = Check.in_console

---@type LazySpecs
local Editing = {
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        version = false,
        dependencies = {
            { 'RRethy/nvim-treesitter-endwise', event = 'InsertEnter', version = false },
        },
        config = source('plugin.autopairs'),
    },
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        version = false,
        config = source('plugin.persistence'),
    },

    {
        'folke/twilight.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.twilight'),
        cond = not in_console(),
    },
    {
        'numToStr/Comment.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        config = source('plugin.Comment'),
    },

    {
        'tpope/vim-endwise',
        lazy = false,
        version = false,
        init = flag_installed('endwise'),
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
        config = source('plugin.todo_comments'),
        cond = executable('rg') and not in_console(),
    },
    {
        'vim-scripts/a.vim',
        event = 'VeryLazy',
        version = false,
        init = flag_installed('a_vim'),
        config = source('plugin.a_vim'),
    },
    {
        'folke/zen-mode.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.zen_mode'),
        cond = not in_console(),
    },
    {
        'julienvincent/nvim-paredit',
        version = false,
        config = source('plugin.paredit'),
    },
}

return Editing

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
