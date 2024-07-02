---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
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
    M.themes.tokyonight = require('tokyonight.colors').setup({ transform = true })
end

if exists('catppuccin.palettes') then
    M.themes.catppuccin_macchiato = require('catppuccin.palettes').get_palette('macchiato')
    M.themes.catppuccin_mocha = require('catppuccin.palettes').get_palette('mocha')
    M.themes.catppuccin_frappe = require('catppuccin.palettes').get_palette('frappe')
end

if exists('nightfox') then
    M.themes.nightfox = require('nightfox.palette').load()
end

function M:transform()
    ---@type table<string, JLine.Theme.Spec>
    local transform_tbl = {
        default = self.themes.default,
        tokyonight = {
            bg = self.themes.tokyonight.bg_statusline,
            fg = self.themes.tokyonight.fg_sidebar,
            darkblue = self.themes.tokyonight.bg_float,
            red = self.themes.tokyonight.red.base,
            green = self.themes.tokyonight.green.base,
            yellow = self.themes.tokyonight.yellow.base,
            violet = self.themes.tokyonight.purple,
            cyan = self.themes.tokyonight.teal,
            blue = self.themes.tokyonight.blue.base,
            magenta = self.themes.tokyonight.magenta.base,
            orange = self.themes.tokyonight.orange.base,
        },
    }

    self.curr_theme = transform_tbl
end

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
M.new = function(variant)
    variant = (is_str(variant) and not empty(variant)) and variant or 'default'

    local self = setmetatable({}, { __index = M })
    self.themes = M.themes
    self.variant = variant

    return self
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
