---@module 'lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local flag_installed = CfgUtil.flag_installed
local in_console = Check.in_console

---@type LazySpec[]
local Syntax = {
    { import = 'plugin.doxygen' },
    {
        'rhysd/vim-syntax-codeowners',
        lazy = false,
        version = false,
        init = flag_installed('codeowners'),
    },
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        ft = { 'org' },
        version = false,
        config = CfgUtil.require('plugin.orgmode'),
        cond = not in_console(),
    },
}

return Syntax

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
