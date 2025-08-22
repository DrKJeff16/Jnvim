---@module 'config.lazy'

local CfgUtil = require('config.util')

local executable = require('user_api.check.exists').executable
local flag_installed = CfgUtil.flag_installed
local source = CfgUtil.source

---@type LazySpecs
local Utils = {
    {
        'vim-scripts/UTL.vim',
        version = false,
        init = flag_installed('utl'),
    },
}

return Utils

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
