---@module 'lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local in_console = Check.in_console

---@type LazySpec[]
local UI = {
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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
