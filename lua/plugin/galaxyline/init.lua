---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local Highlight = User.highlight
local Types = User.types.galaxyline

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local empty = Check.value.empty

if not exists('galaxyline') then
    return
end

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opt_get = vim.api.nvim_get_option_value

local GROUP = augroup('JLine', { clear = false })

local Devicons = require('nvim-web-devicons')
local GL = require('galaxyline')
local Extensions = require('galaxyline.provider_extensions')

local JLineUtils = require('plugin..galaxyline.util').new('tokyonight')

local default_colors = JLineUtils:palette()

_G.VistaPlugin = Extensions.vista_nearest

GL.short_line_list = {
    'LuaTree',
    'NvimTree',
    'vista',
    'dbui',
    'startify',
    'term',
    'nerdtree',
    'fugitive',
    'fugitiveblame',
    'plug',
    'plugins',
}

local Providers = {
    -- source provider function
    diagnostic = require('galaxyline.provider_diagnostic'),
    vcs = require('galaxyline.provider_vcs'),
    fileinfo = require('galaxyline.provider_fileinfo'),
    colors = require('galaxyline.colors'),
    buffer = require('galaxyline.provider_buffer'),
    whitespace = require('galaxyline.provider_whitespace'),
    lsp = require('galaxyline.provider_lsp'),
}

--- Set buffer variables for file icon and color.
---@return { color: string, icon: string }
local function buf_init_devicons()
    local icon, color = Devicons.get_icon(vim.fn.expand('%:t'), vim.fn.expand('%:e'), { default = true })
    local dev_icons = { color = vim.api.nvim_get_hl(0, { link = false, name = color }).fg, icon = icon }

    vim.b.dev_icons = dev_icons
    return dev_icons
end

--- @return { color: string|integer, icon: string }
local function filetype_info()
    return vim.b.dev_icons or buf_init_devicons()
end

local SEPARATORS = {
    --- Components separated by this component will be padded with an equal number of spaces.
    align = { provider = '%=' },
    --- A left separator.
    left_separator = { provider = '' },
    --- A right separator.
    right_separator = { provider = ' ' },
}

-- require('plugin..galaxyline.spaceline')
require('plugin..galaxyline.eviline')
GL.load_galaxyline()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
