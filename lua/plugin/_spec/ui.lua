---@module 'lazy'

local CfgUtil = require('config.util')

---@type LazySpec[]
return {
    -- Start Greeter
    {
        'goolord/alpha-nvim',
        lazy = false,
        priority = 1000,
        version = false,
        dependencies = {
            'echasnovski/mini.icons',
            'nvim-lua/plenary.nvim',
        },
        config = CfgUtil.require('plugin.alpha'),
    },
    {
        'akinsho/toggleterm.nvim',
        event = 'VeryLazy',
        version = false,
        config = CfgUtil.require('plugin.toggleterm'),
        enabled = not require('user_api.check').in_console(),
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
