---@module 'user_api.types.lazy'

local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')

local source = CfgUtil.source
local flag_installed = CfgUtil.flag_installed
local in_console = Check.in_console

---@type (LazySpec)[]
local Utils = {
    {
        'vim-scripts/UTL.vim',
        lazy = false,
        version = false,
        init = flag_installed('utl'),
    },
    --- Makefile viewer
    {
        'Zeioth/makeit.nvim',
        ft = 'make',
        version = false,
        dependencies = { 'stevearc/overseer.nvim' },
        opts = {},
        cond = not in_console(),
    },
    --- The task runner used for `makeit.nvim`
    {
        'stevearc/overseer.nvim',
        lazy = true,
        version = false,
        config = source('plugin.overseer'),
        cond = not in_console(),
    },
    --- Docs viewer
    {
        'Zeioth/dooku.nvim',
        cmd = {
            'DookuOpen',
            'DookuAutoSetup',
            'DookuGenerate',
        },
        version = false,
        config = source('plugin.dooku'),
        cond = not in_console(),
    },
}

return Utils

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
