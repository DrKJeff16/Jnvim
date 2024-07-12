---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local Types = User.types.galaxyline

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local empty = Check.value.empty

if not exists('galaxyline') then
    return
end

local opt_get = vim.api.nvim_get_option_value

local Devicons = require('nvim-web-devicons')

local buf_init_devicons = Devicons.get_icon_cterm_color_by_filetype

---@type JLine.Util
---@diagnostic disable-next-line:missing-fields
local M = {
    variant = 'default',

    dimensions = function()
        ---@type integer
        local cols = vim.opt.columns:get()
        ---@type integer
        local lines = vim.opt.lines:get()

        return { cols, lines }
    end,

    file_readonly = function(icon)
        icon = (is_str(icon) and not empty(icon)) and icon or ''

        return vim.bo.readonly and vim.bo.filetype ~= 'help' and ' ' .. icon .. ' ' or ''
    end,

    themes = {
        --- Obviously works
        default = require('galaxyline.theme').default,
    },
}

if exists('tokyonight') then
    M.themes.tokyonight = (function()
        local TN = require('tokyonight.colors').setup({ transform = false })
        ---@type JLine.Theme.Spec
        return {
            bg = TN.bg_statusline,
            fg = TN.fg_sidebar,
            darkblue = TN.bg_float,
            red = TN.red.base,
            green = TN.green.base,
            yellow = TN.yellow.base,
            violet = TN.purple,
            cyan = TN.teal,
            blue = TN.blue.base,
            magenta = TN.magenta.base,
            orange = TN.orange.base,
        }
    end)()
end

---@param variant 'frappe'|'mocha'|'macchiato'
---@return JLine.Theme.Spec
local function catppuccin_adapt(variant)
    local CTP = require('catppuccin.palettes').get_palette(variant)

    local op = require('catppuccin.utils.colors').darken

    ---@type JLine.Theme.Spec
    return {
        bg = CTP.mantle,
        fg = CTP.subtext1,
        darkblue = CTP.bg_float,
        red = CTP.red,
        green = CTP.green,
        yellow = CTP.yellow,
        violet = op(CTP.mauve, 15, CTP.mantle),
        cyan = CTP.teal,
        blue = CTP.blue,
        magenta = CTP.maroon,
        orange = CTP.peach,
    }
end

if exists('catppuccin.palettes') then
    M.themes.catppuccin_macchiato = catppuccin_adapt('macchiato')
    M.themes.catppuccin_mocha = catppuccin_adapt('mocha')
    M.themes.catppuccin_frappe = catppuccin_adapt('frappe')
end

if exists('nightfox') then
    M.themes.nightfox = require('nightfox.palette').load()
end

--- Set buffer variables for file icon and color.
---@return { color: string, icon: string }
function M.buf_init_devicons()
    local icon, color = Devicons.get_icon(vim.fn.expand('%:t'), vim.fn.expand('%:e'), { default = true })
    local dev_icons = { color = vim.api.nvim_get_hl(0, { link = false, name = color }).fg, icon = icon }

    vim.b.dev_icons = dev_icons
    return dev_icons
end

--- @return { color: string|integer, icon: string }
function M.filetype_info()
    return vim.b.dev_icons or M.buf_init_devicons()
end

---@return JLine.Theme.Spec
function M:palette()
    return not is_nil(self.themes[self.variant]) and self.themes[self.variant] or self.themes.default
end

---@return string
function M:check_bg()
    if vim.o.background == 'dark' then
        return self.themes[self.variant].darkblue
    end

    return self.themes[self.variant].fg
end

---@param variant? string
---@return JLine.Util
M.new = function(variant)
    variant = (is_str(variant) and not empty(variant)) and variant or 'default'

    local self = setmetatable({}, { __index = M })
    self.themes = M.themes
    self.variant = variant

    return self
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
