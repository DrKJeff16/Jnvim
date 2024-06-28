---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type LazySpec[]
local M = {
    {
        'iamcco/markdown-preview.nvim',
        build = executable('yarn') and 'cd app && yarn install' or '',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        config = source('plugin.md_preview'),
        enabled = not in_console(),
    },
}

return M
