---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local source = CfgUtil.source
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type (LazySpec)[]
local TS = {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        version = false,
        config = source('plugin.treesitter'),
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        version = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        cond = not in_console() and vim_exists('+termguicolors'),
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        version = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        version = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    {
        'nvim-treesitter/nvim-treesitter-refactor',
        version = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
}

return TS

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
