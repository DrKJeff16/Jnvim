---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local vim_exists = Check.exists.vim_exists
local vim_has = Check.exists.vim_has
local in_console = Check.in_console
local luarocks_check = CfgUtil.luarocks_check

---@type (LazySpec)[]
local M = {
    {
        'folke/zen-mode.nvim',
        lazy = true,
        version = false,
        config = source('plugin.zen_mode'),
    },
    {
        'nvim-neorg/neorg',
        ft = 'norg',
        version = false,
        config = source('plugin.neorg'),
        enabled = luarocks_check() and vim_has('nvim-0.10'),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
