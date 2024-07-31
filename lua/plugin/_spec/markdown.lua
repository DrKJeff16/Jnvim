---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console
local is_root = Check.is_root

---@type (LazySpec)[]
local M = {
    {
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        version = false,
        build = executable('yarn') and 'cd app && yarn install' or '',
        init = function() vim.g.mkdp_filetypes = { 'markdown' } end,
        config = source('plugin.markdown.md_preview'),
        cond = not (in_console() or is_root()),
    },
    {
        'tadmccorkle/markdown.nvim',
        ft = 'markdown',
        version = false,
        config = source('plugin.markdown'),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
