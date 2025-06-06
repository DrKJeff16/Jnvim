---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')

local source = CfgUtil.source

---@type (LazySpec)[]
local M = {
    {
        'nvim-neorg/neorg',
        ft = 'norg',
        version = false,
        config = source('plugin.neorg'),
        enabled = false,
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
