---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local empty = Check.value.empty

if not exists('lualine') then
    return
end

local Lualine = require('lualine')

local Presets = require('plugin.lualine.presets')

---@type fun(theme: string?, force_auto: boolean?): string
local function theme_select(theme, force_auto)
    theme = (is_str(theme) and not empty(theme)) and theme or 'auto'

    force_auto = is_bool(force_auto) and force_auto or false

    -- If `auto` theme and permitted to select from fallbacks.
    -- Keep in mind these fallbacks are the same strings as their `require()` module strings
    if theme == 'auto' and not force_auto then
        for _, t in next, { 'nightfox', 'onedark', 'catppuccin', 'tokyonight' } do
            if exists(t) then
                theme = t
                break -- Be contempt with the first theme you find
            end
        end
    end

    return theme
end

local Opts = {
    options = {
        icons_enabled = true,
        theme = theme_select('nightfox', true),
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        ignore_focus = {},
        always_divide_middle = true,
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
        'fugitive',
        'man',
    },
}

if exists('lazy') then
    table.insert(Opts.extensions, 'lazy')
end
if exists('nvim-tree') then
    table.insert(Opts.extensions, 'nvim-tree')
end
if exists('toggleterm') then
    table.insert(Opts.extensions, 'toggleterm')
end

Lualine.setup(Opts)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
