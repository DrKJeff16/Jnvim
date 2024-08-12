---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check
local types = User.types.telescope

local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local executable = Check.exists.executable

if not exists('telescope') or not exists('telescope._extensions.file_browser') then
    return
end

local in_tbl = vim.tbl_contains
local empty = vim.tbl_isempty
local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local Telescope = require('telescope')
local Actions = require('telescope._extensions.file_browser.actions')
local Finders = require('telescope._extensions.file_browser.finders')

local load_ext = Telescope.load_extension

local M = {}
M.file_browser = {
    cwd_to_path = true,
    grouped = false,
    files = true,
    add_dirs = true,
    depth = 1,
    auto_depth = true,
    select_buffer = false,
    hidden = { file_browser = false, folder_browser = false },
    respect_gitignore = executable('fd'),
    use_fd = executable('fd'),
    display_stat = { date = true, size = true, mode = true },
    git_status = true,
    quiet = false,
    browse_files = Finders.browse_files,
    browse_folders = Finders.browse_folders,
    follow_symlinks = false,
    hide_parent_dir = false,
    collapse_dirs = false,
    prompt_path = false,
    dir_icon = '',
    dir_icon_hl = 'Default',
    no_ignore = false,
    theme = 'ivy',
    hijack_netrw = not exists('nvim-tree'),
    mappings = {
        ['i'] = {
            ['<A-c>'] = Actions.create,
            ['<S-CR>'] = Actions.create_from_prompt,
            ['<A-r>'] = Actions.rename,
            ['<A-m>'] = Actions.move,
            ['<A-y>'] = Actions.copy,
            ['<A-d>'] = Actions.remove,
            ['<C-o>'] = Actions.open,
            ['<C-g>'] = Actions.goto_parent_dir,
            ['<C-e>'] = Actions.goto_home_dir,
            ['<C-w>'] = Actions.goto_cwd,
            ['<A-t>'] = Actions.change_cwd,
            ['<C-f>'] = Actions.toggle_browser,
            ['<C-h>'] = Actions.toggle_hidden,
            ['<C-s>'] = Actions.toggle_all,
            ['<bs>'] = Actions.backspace,
        },
        ['n'] = {
            ['c'] = Actions.create,
            ['r'] = Actions.rename,
            ['m'] = Actions.move,
            ['y'] = Actions.copy,
            ['d'] = Actions.remove,
            ['o'] = Actions.open,
            ['g'] = Actions.goto_parent_dir,
            ['e'] = Actions.goto_home_dir,
            ['w'] = Actions.goto_cwd,
            ['t'] = Actions.change_cwd,
            ['f'] = Actions.toggle_browser,
            ['h'] = Actions.toggle_hidden,
            ['s'] = Actions.toggle_all,
        },
    },
}

function M.loadkeys()
    local Maps = User.maps

    local map_dict = Maps.map_dict
    local desc = Maps.kmap.desc

    ---@type table<MapModes, KeyMapDict>
    local Keys = {
        n = {
            ['<leader>fTeb'] = {
                require('telescope').extensions.file_browser.file_browser,
                desc('File Browser'),
            },
            ['<leader>ff'] = {
                require('telescope').extensions.file_browser.file_browser,
                desc('Telescope File Browser'),
            },
        },
        v = {
            ['<leader>fTeb'] = {
                require('telescope').extensions.file_browser.file_browser,
                desc('File Browser'),
            },
            ['<leader>ff'] = {
                require('telescope').extensions.file_browser.file_browser,
                desc('Telescope File Browser'),
            },
        },
    }

    map_dict(Keys, 'wk.register', true, nil, 0)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
