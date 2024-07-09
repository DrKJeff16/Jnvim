---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable

---@type (LazySpec)[]
local M = {
    {
        'rhysd/vim-syntax-codeowners',
        event = 'VeryLazy',
        version = false,
    },
    {
        'vim-scripts/DoxygenToolkit.vim',
        event = 'VeryLazy',
        version = false,
        cond = executable('doxygen'),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
