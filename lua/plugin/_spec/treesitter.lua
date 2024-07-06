---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type (LazySpec)[]
local M = {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        version = false,
        config = source('plugin.treesitter'),
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        lazy = true,
        version = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        cond = not in_console() and vim_exists('+termguicolors'),
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = true,
        version = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        lazy = true,
        version = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
