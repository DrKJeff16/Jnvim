---@module 'config.lazy'

local CfgUtil = require('config.util')
local Termux = require('user_api.distro.termux')

local source = CfgUtil.source
local in_console = require('user_api.check').in_console

---@type LazySpecs
local Neorg = {
    {
        'nvim-neorg/neorg',
        version = false,
        config = source('plugin.neorg'),
        cond = not (Termux:validate() or in_console()),
    },
}

return Neorg

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
