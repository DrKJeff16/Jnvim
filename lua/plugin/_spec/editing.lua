---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local Check = require('user_api.check')

local source = CfgUtil.source
local set_tgc = CfgUtil.set_tgc
local flag_installed = CfgUtil.flag_installed
local executable = Check.exists.executable
local in_console = Check.in_console

---@type LazySpecs
local Editing = {
    {
        'folke/persistence.nvim',
        lazy = false,
        version = false,
        config = source('plugin.persistence'),
        enabled = false,
    },
    {
        'olimorris/persisted.nvim',
        lazy = false,
        version = false,
        config = source('plugin.persisted'),
    },
    {
        'folke/twilight.nvim',
        lazy = true,
        version = false,
        config = source('plugin.twilight'),
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
        init = set_tgc(),
        config = source('plugin.todo_comments'),
        cond = executable('rg'),
    },
    {
        'windwp/nvim-autopairs',
        main = 'nvim-autopairs',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.autopairs'),
    },
    {
        'vim-scripts/a.vim',
        version = false,
        init = flag_installed('a_vim'),
        config = source('plugin.a_vim'),
    },
    {
        'folke/zen-mode.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.zen_mode'),
    },
    {
        'julienvincent/nvim-paredit',
        version = false,
        config = source('plugin.paredit'),
    },
}

return Editing

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
