local User = require('user_api')
local Check = User.check
local Termux = User.distro.termux

local exists = Check.exists.module
local is_bool = Check.value.is_bool
local type_not_empty = Check.value.type_not_empty

local in_tbl = vim.tbl_contains

if not exists('lualine') then
    User.deregister_plugin('plugin.lualine')
    return
end

local Lualine = require('lualine')

local Presets = require('plugin.lualine.presets')

---@param theme? ''|'auto'|string
---@param force_auto? boolean
---@return string
local function theme_select(theme, force_auto)
    theme = type_not_empty('string', theme) and theme or 'auto'
    force_auto = is_bool(force_auto) and force_auto or false

    -- If `auto` theme and permitted to select from fallbacks.
    -- Keep in mind these fallbacks are the same strings as their `require()` module strings
    if in_tbl({ 'auto', '' }, theme) or force_auto then
        return 'auto'
    end

    local themes = {
        'tokyonight',
        'catppuccin',
        'nightfox',
        'onedark',
    }

    if not in_tbl(themes, theme) then
        return 'auto'
    end

    for _, t in next, themes do
        if t == theme and exists(theme) then
            return theme
        end
    end

    return 'auto'
end

local Opts = {
    options = {
        icons_enabled = true,
        theme = theme_select('catppuccin', false),
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        ignore_focus = {},
        always_divide_middle = Termux.validate(),
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    sections = Presets.default,
    inactive_sections = Presets.default_inactive,
    inactive_tabline = {},
    inactive_winbar = {},

    extensions = {
        'lazy',
        'fugitive',
        'man',
    },
}

if exists('nvim-tree') and not in_tbl(Opts.extensions, 'nvim-tree') then
    table.insert(Opts.extensions, 'nvim-tree')
end
if exists('toggleterm') and not in_tbl(Opts.extensions, 'toggleterm') then
    table.insert(Opts.extensions, 'toggleterm')
end

Lualine.setup(Opts)

User.register_plugin('plugin.lualine')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
