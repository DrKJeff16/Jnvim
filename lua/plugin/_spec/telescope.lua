---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local tel_fzf_build = CfgUtil.tel_fzf_build
local executable = Check.exists.executable
local in_console = Check.in_console

---@type LazySpec[]
local M = {
    {
        'nvim-telescope/telescope.nvim',
        version = false,
        dependencies = {
            'plenary.nvim',
        },
        config = source('plugin.telescope'),
        enabled = not in_console(),
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        lazy = true,
        version = false,
        enabled = not in_console(),
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        lazy = true,
        version = false,
        build = tel_fzf_build(),
        enabled = executable('fzf') and not in_console(),
    },
    --- Project Manager
    {
        'ahmedkhalf/project.nvim',
        lazy = false,
        main = 'project_nvim',
        version = false,
        init = function()
            vim.opt.ls = 2
            vim.opt.stal = 2
            vim.o.autochdir = true
        end,
        config = source('plugin.project'),
    },
}

return M
