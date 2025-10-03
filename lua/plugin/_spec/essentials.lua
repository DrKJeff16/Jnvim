---@module 'lazy'

local CfgUtil = require('config.util')

---@type LazySpec[]
local Essentials = {
    {
        'MunifTanjim/nui.nvim',
        version = false,
    },
    {
        'nvim-mini/mini.nvim',
        version = false,
        config = CfgUtil.require('plugin.mini'),
    },
    {
        'nvim-lua/plenary.nvim',
        lazy = true,
        version = false,
    },
    {
        'gennaro-tedesco/nvim-possession',
        version = false,
        dependencies = {
            { 'ibhagwan/fzf-lua' },
        },
        config = CfgUtil.require('plugin.possession'),
    },
}

return Essentials

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
