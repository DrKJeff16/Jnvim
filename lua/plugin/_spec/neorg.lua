---@module 'lazy'
---@module 'config.lazy'

local CfgUtil = require('config.util')
local Termux = require('user_api.distro.termux')

local source = CfgUtil.source
local in_console = require('user_api.check').in_console
local luarocks_check = CfgUtil.luarocks_check

---@type LazySpecs
local Neorg = {
    {
        'nvim-neorg/neorg',
        version = false,
        dependencies = {
            {
                'vhyrro/luarocks.nvim',
                version = false,
                config = source('plugin.luarocks'),
                cond = luarocks_check() and not Termux.validate(),
            },
        },
        config = source('plugin.neorg'),
        cond = not (Termux.validate() or in_console()),
        enabled = false,
    },
}

return Neorg

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
