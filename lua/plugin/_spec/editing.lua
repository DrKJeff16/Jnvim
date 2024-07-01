---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

--- NOTE: This is a global defined in `user`
local Flags = ACTIVATION_FLAGS.plugins.editing ---@see User.ActivationFlags

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type LazySpec[]
local M = {
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        version = false,
        config = source('plugin.persistence'),
        enabled = Flags.persistence and not Flags.persisted,
    },
    {
        'olimorris/persisted.nvim',
        lazy = false,
        version = false,
        config = source('plugin.persisted'),
        enabled = Flags.persisted and not Flags.persistence,
    },
    {
        'numToStr/Comment.nvim',
        version = false,
        dependencies = {
            'nvim-treesitter',
            'nvim-ts-context-commentstring',
        },
        config = source('plugin.Comment'),
        enabled = Flags.comment and ACTIVATION_FLAGS.plugins.treesitter,
    },

    {
        'tpope/vim-endwise',
        lazy = false,
        version = false,
        enabled = Flags.endwise,
    },
    --- TODO COMMENTS
    {
        'folke/todo-comments.nvim',
        version = false,
        init = function()
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('plugin.todo_comments'),
        enabled = Flags.todo_comments and executable('rg') and not in_console(),
    },
    {
        'windwp/nvim-autopairs',
        main = 'nvim-autopairs',
        version = false,
        config = source('plugin.autopairs'),
        enabled = Flags.autopairs,
    },
    {
        'glepnir/template.nvim',
        version = false,
        config = source('plugin.template'),
        enabled = Flags.template,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
