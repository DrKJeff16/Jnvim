local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local set_tgc = CfgUtil.set_tgc
local flag_installed = CfgUtil.flag_installed
local executable = Check.exists.executable
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type (LazySpec)[]
local M = {
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        version = false,
        config = source('plugin.persistence'),
        enabled = false,
    },
    {
        'olimorris/persisted.nvim',
        event = 'BufReadPre',
        version = false,
        config = source('plugin.persisted'),
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
        event = 'BufReadPre',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-lua/plenary.nvim',
        },
        init = set_tgc(),
        config = source('plugin.todo_comments'),
        cond = executable('rg') and not in_console(),
    },
    {
        'windwp/nvim-autopairs',
        main = 'nvim-autopairs',
        version = false,
        config = source('plugin.autopairs'),
    },
    {
        'vim-scripts/a.vim',
        ft = { 'c', 'cpp' },
        version = false,
        init = flag_installed('a_vim'),
        config = function()
            require('user_api.maps').nop({
                'ihn',
                'is',
                'ih',
            }, {
                noremap = true,
                silent = true,
                buffer = 0,
            }, 'i', '<Space>') -- TODO: Make a `get_leader() function`
        end,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
