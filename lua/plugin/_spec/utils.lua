local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type (LazySpec)[]
local M = {
    {
        'vim-scripts/UTL.vim',
        lazy = false,
        version = false,
        init = function() vim.g.utl_installed = 1 end,
    },
    --- Makefile viewer
    {
        'Zeioth/makeit.nvim',
        ft = { 'make' },
        version = false,
        dependencies = { 'stevearc/overseer.nvim' },
        opts = {},
        cond = not in_console(),
    },
    --- The task runner used for `makeit.nvim`
    {
        'stevearc/overseer.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.overseer'),
        cond = not in_console(),
    },
    --- Docs viewer
    {
        'Zeioth/dooku.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.dooku'),
        cond = not in_console(),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
