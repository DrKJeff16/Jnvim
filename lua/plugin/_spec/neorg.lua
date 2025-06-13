---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local Termux = require('user_api.distro.termux')

local source = CfgUtil.source

---@type (LazySpec)[]
local Neorg = {
    {
        'nvim-neorg/neorg',
        ft = 'norg',
        version = false,
        config = source('plugin.neorg'),
        enabled = not Termux:validate(),
    },
}

return Neorg

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
