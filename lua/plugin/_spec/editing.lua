---@module 'config.lazy'

local CfgUtil = require('config.util')
local Check = require('user_api.check')

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
        config = CfgUtil.require('plugin.autopairs'),
    },
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
    {
        'numToStr/Comment.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        config = CfgUtil.require('plugin.Comment'),
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
        config = CfgUtil.require('plugin.todo_comments'),
        cond = executable('rg') and not in_console(),
    },
    {
        'vim-scripts/a.vim',
        event = 'VeryLazy',
        version = false,
        init = flag_installed('a_vim'),
        config = CfgUtil.require('plugin.a_vim'),
    },
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
    {
        'mfussenegger/nvim-lint',
        version = false,
        config = function()
            require('lint').linters_by_ft = {
                lua = { 'selene' },
            }

            vim.api.nvim_create_autocmd('BufWritePost', {
                group = vim.api.nvim_create_augroup('nvim-lint', { clear = false }),
                callback = function()
                    -- try_lint without arguments runs the linters defined in `linters_by_ft`
                    -- for the current filetype
                    require('lint').try_lint()
                end,
            })
        end,
    },
}

return Editing

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
