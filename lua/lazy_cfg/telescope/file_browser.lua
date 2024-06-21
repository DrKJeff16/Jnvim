---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.telescope
local kmap = User.maps.kmap
local WK = User.maps.wk

local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local executable = Check.exists.executable
local desc = kmap.desc

if not exists('telescope') or not exists('telescope._extensions.file_browser') then
    return
end

local in_tbl = vim.tbl_contains
local empty = vim.tbl_isempty
local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local Telescope = require('telescope')
local Extensions = Telescope.extensions

local load_ext = Telescope.load_extension

local M = {
    cwd_to_path = false,
    grouped = false,
    files = true,
    add_dirs = true,
    depth = 1,
    auto_depth = true,
    select_buffer = false,
    hidden = { file_browser = false, folder_browser = false },
    respect_gitignore = executable('fd'),
    no_ignore = false,
    theme = 'ivy',
    hijack_netrw = true,
    mappings = {
        i = {},
        n = {},
    },
}

return M
