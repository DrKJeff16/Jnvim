---@module 'lazy'

local CfgUtil = require('config.util')

---@type LazySpec[]
return {
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
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
