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
        dependencies = { 'plenary.nvim' },
        config = source('plugin.telescope'),
        cond = not in_console(),
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        lazy = true,
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
        cond = not in_console(),
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        lazy = true,
        version = false,
        build = tel_fzf_build(),
        dependencies = { 'nvim-telescope/telescope.nvim' },
        cond = executable('fzf') and not in_console(),
    },
    -- TODO: Split into its file
    {
        'LukasPietzschmann/telescope-tabs',
        event = 'TabNew',
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function()
            require('telescope').load_extension('telescope-tabs')
            require('telescope-tabs').setup({
                entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
                    local entry_string = table.concat(file_names, ', ')
                    return string.format('%d: %s%s', tab_id, entry_string, is_current and ' <' or '')
                end,
                entry_ordinal = function(tab_id, buffer_ids, file_names, file_paths, is_current)
                    return table.concat(file_names, ' ')
                end,
                show_preview = true,
                close_tab_shortcut_i = '<C-d>', -- if you're in insert mode
                close_tab_shortcut_n = 'D', -- if you're in normal mode
            })
        end,
    },
    {
        'DrKJeff16/telescope-makefile',
        ft = { 'make' },
        version = false,
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'akinsho/toggleterm.nvim',
        },
        config = function()
            require('telescope-makefile').setup({})

            require('telescope').load_extension('make')
        end,
    },
    {
        'olacin/telescope-cc.nvim',
        ft = { 'gitcommit' },
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },
    --- Project Manager
    {
        'ahmedkhalf/project.nvim',
        event = 'VeryLazy',
        dev = true,
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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
