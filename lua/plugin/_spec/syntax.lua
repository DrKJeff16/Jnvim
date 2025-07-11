---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local source = CfgUtil.source
local flag_installed = CfgUtil.flag_installed
local in_console = Check.in_console
local executable = Check.exists.executable

---@type LazySpecs
local Syntax = {
    {
        'rhysd/vim-syntax-codeowners',
        lazy = false,
        version = false,
        init = flag_installed('codeowners'),
    },
    {
        'vim-scripts/DoxygenToolkit.vim',
        ft = { 'c', 'cpp' },
        version = false,
        init = flag_installed('doxygen_toolkit'),
        config = source('plugin.doxygen'),
        cond = executable('doxygen'),
    },
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        ft = { 'org' },
        version = false,
        config = source('plugin.orgmode'),
        cond = not in_console(),
    },
}

return Syntax

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
