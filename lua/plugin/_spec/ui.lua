---@module 'lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local in_console = Check.in_console

---@type LazySpec[]
local UI = {
    { import = 'plugin.noice' },
    -- Start Greeter
    {
        'goolord/alpha-nvim',
        lazy = false,
        priority = 1000,
        version = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'nvim-lua/plenary.nvim',
        },
        config = CfgUtil.require('plugin.alpha'),
    },

    -- Statusline
    { import = 'plugin.lualine' },

    -- Tabline
    {
        'akinsho/bufferline.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'tiagovla/scope.nvim',
        },
        config = CfgUtil.require('plugin.bufferline'),
        cond = not in_console(),
    },

    -- Indent Scope
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        version = false,
        dependencies = {
            {
                'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
                version = false,
                config = CfgUtil.require('plugin.rainbow_delimiters'),
            },
        },
        config = CfgUtil.require('plugin.ibl'),
        -- cond = not in_console(),
    },

    -- -- File Tree
    -- {
    --     'nvim-tree/nvim-tree.lua',
    --     main = 'nvim-tree',
    --     event = 'VeryLazy',
    --     version = false,
    --     dependencies = { 'nvim-web-devicons' },
    --     config = CfgUtil.require('plugin.nvim_tree'),
    -- },
    { import = 'plugin.neo_tree' },

    {
        'akinsho/toggleterm.nvim',
        event = 'VeryLazy',
        version = false,
        config = CfgUtil.require('plugin.toggleterm'),
        cond = not in_console(),
    },

    {
        'folke/paint.nvim',
        version = false,
        config = function()
            require('paint').setup({
                ---@type PaintHighlight[]
                highlights = {
                    {
                        -- filter can be a table of buffer options that should match,
                        -- or a function called with buf as param that should return true.
                        -- The example below will paint @something in comments with Constant
                        filter = { filetype = 'lua' },
                        pattern = '%s*%-%-%-%s*(@%w+)',
                        hl = 'Constant',
                    },
                },
            })
        end,
        cond = not in_console(),
    },
}

return UI

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
