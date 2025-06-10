local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local empty = Check.value.empty

local tbl_contains = vim.tbl_contains

if not exists('lualine') then
    return
end

User:register_plugin('plugin.lualine')

local Lualine = require('lualine')

local Presets = require('plugin.lualine.presets')

---@param theme? ''|'auto'|string
---@param force_auto? boolean
---@return string
local function theme_select(theme, force_auto)
    theme = is_str(theme) and theme or 'auto'
    theme = not empty(theme) and theme or 'auto'

    force_auto = is_bool(force_auto) and force_auto or false

    local themes = {
        'tokyonight',
        'catppuccin',
        'nightfox',
        'onedark',
    }

    -- If `auto` theme and permitted to select from fallbacks.
    -- Keep in mind these fallbacks are the same strings as their `require()` module strings
    if theme == 'auto' and not force_auto then
        for _, t in next, themes do
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
        theme = theme_select('auto', false),
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

if exists('lazy') and not tbl_contains(Opts.extensions, 'lazy') then
    table.insert(Opts.extensions, 'lazy')
end
if exists('nvim-tree') and not tbl_contains(Opts.extensions, 'nvim-tree') then
    table.insert(Opts.extensions, 'nvim-tree')
end
if exists('toggleterm') and not tbl_contains(Opts.extensions, 'toggleterm') then
    table.insert(Opts.extensions, 'toggleterm')
end

Lualine.setup(Opts)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
