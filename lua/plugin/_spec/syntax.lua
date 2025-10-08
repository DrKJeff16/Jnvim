---@module 'lazy'

local CfgUtil = require('config.util')
local flag_installed = CfgUtil.flag_installed

---@type LazySpec[]
return {
    {
        'rhysd/vim-syntax-codeowners',
        lazy = false,
        version = false,
        init = flag_installed('codeowners'),
    },
    {
        'nvim-orgmode/orgmode',
        ft = 'org',
        version = false,
        config = CfgUtil.require('plugin.orgmode'),
        cond = not require('user_api.check').in_console(),
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
