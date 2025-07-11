---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local in_console = Check.in_console
local source = CfgUtil.source
local flag_installed = CfgUtil.flag_installed

---@type LazySpecs
local Utils = {
    {
        'vim-scripts/UTL.vim',
        event = 'VeryLazy',
        version = false,
        init = flag_installed('utl'),
    },
    --- Docs viewer
    {
        'Zeioth/dooku.nvim',
        cmd = {
            'DookuOpen',
            'DookuAutoSetup',
            'DookuGenerate',
        },
        version = false,
        config = source('plugin.dooku'),
        cond = not in_console(),
        enabled = false,
    },
}

return Utils

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
