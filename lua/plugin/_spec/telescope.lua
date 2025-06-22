---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local source = CfgUtil.source
local tel_fzf_build = CfgUtil.tel_fzf_build
local executable = Check.exists.executable
local in_console = Check.in_console

---@type (LazySpec)[]
local Telescope = {
    {
        'nvim-telescope/telescope.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = { 'plenary.nvim' },
        config = source('plugin.telescope'),
    },
    {
        'OliverChao/telescope-picker-list.nvim',
        lazy = true,
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        lazy = true,
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        lazy = true,
        version = false,
        build = tel_fzf_build(),
        dependencies = { 'nvim-telescope/telescope.nvim' },
        cond = executable('fzf'),
    },
    -- TODO: Split into its file
    {
        'LukasPietzschmann/telescope-tabs',
        event = 'VeryLazy',
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function()
            require('telescope').load_extension('telescope-tabs')
            require('telescope-tabs').setup({
                entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
                    local entry_string = table.concat(file_names, ', ')
                    return string.format(
                        '%d: %s%s',
                        tab_id,
                        entry_string,
                        is_current and ' <' or ''
                    )
                end,
                entry_ordinal = function(
                    tab_id,
                    buffer_ids,
                    file_names,
                    file_paths,
                    is_current
                )
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
        ft = 'make',
        version = false,
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'akinsho/toggleterm.nvim',
        },
        config = function()
            require('telescope-makefile').setup({})

            require('telescope').load_extension('make')
        end,
        cond = (executable('make') or executable('mingw32-make')) and not in_console(),
    },
    {
        'olacin/telescope-cc.nvim',
        ft = 'gitcommit',
        version = false,
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },
    --- Project Manager
    {
        'DrKJeff16/project.nvim',
        dev = true,
        main = 'project_nvim',
        lazy = false,
        version = false,
        config = source('plugin.project'),
    },
}

return Telescope

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
