---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

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
        enabled = false,
    },
    {
        'olimorris/persisted.nvim',
        lazy = false,
        version = false,
        config = source('plugin.persisted'),
    },
    {
        'numToStr/Comment.nvim',
        version = false,
        dependencies = {
            'nvim-treesitter',
            'nvim-ts-context-commentstring',
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
        version = false,
        dependencies = {
            'nvim-treesitter',
            'plenary.nvim',
        },
        init = function()
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
        end,
        config = source('plugin.todo_comments'),
        enabled = executable('rg') and not in_console(),
    },
    {
        'windwp/nvim-autopairs',
        main = 'nvim-autopairs',
        version = false,
        config = source('plugin.autopairs'),
    },
    {
        'glepnir/template.nvim',
        version = false,
        config = source('plugin.template'),
        enabled = false,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
