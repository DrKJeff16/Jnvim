---@module 'plugin._types.lazy'

local CfgUtil = require('config.util')

local flag_installed = CfgUtil.flag_installed

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
