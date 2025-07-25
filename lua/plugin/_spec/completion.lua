---@module 'config.lazy'

local CfgUtil = require('config.util') ---@see Config.Util
local User = require('user_api')
local Check = User.check

local source = CfgUtil.source
local executable = Check.exists.executable

---@type LazySpecs
local Completion = {
    {
        'saghen/blink.cmp',
        lazy = false,
        version = false,
        dependencies = {
            'L3MON4D3/LuaSnip',
            'folke/lazydev.nvim',
            'onsails/lspkind.nvim',
            'Kaiser-Yang/blink-cmp-git',
            'disrupted/blink-cmp-conventional-commits',
        },
        build = executable('cargo') and 'cargo build --release' or false,
        config = source('plugin.blink_cmp'),
    },
    {
        'L3MON4D3/LuaSnip',
        lazy = true,
        version = false,
        dependencies = { 'rafamadriz/friendly-snippets' },
        build = executable('make') and 'make -j $(nproc) install_jsregexp' or false,
    },
    {
        'onsails/lspkind.nvim',
        version = false,
        config = source('plugin.lspkind'),
    },
}

return Completion

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
