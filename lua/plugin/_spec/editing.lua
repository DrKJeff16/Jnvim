---@module 'lazy'

local CfgUtil = require('config.util')

---@type LazySpec[]
local Editing = {
    {
        'julienvincent/nvim-paredit',
        version = false,
        config = CfgUtil.require('plugin.paredit'),
    },
}

return Editing

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
