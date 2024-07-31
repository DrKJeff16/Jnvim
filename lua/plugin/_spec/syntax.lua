---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local is_root = Check.is_root

---@type (LazySpec)[]
local M = {
    {
        'rhysd/vim-syntax-codeowners',
        event = 'VeryLazy',
        version = false,
        cond = not is_root(),
    },
    {
        'vim-scripts/DoxygenToolkit.vim',
        ft = { 'c', 'cpp' },
        version = false,
        config = source('plugin.doxygen'),
        cond = executable('doxygen'),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
