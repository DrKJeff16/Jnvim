---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local empty = Check.value.empty

if not exists('galaxyline') then
    return
end

local opt_get = vim.api.nvim_get_option_value

---@class JLine.Themes
---@field default table
---@field tokyonight? ColorScheme
---@field catppuccin_mocha? table
---@field catppuccin_macchiato? table
---@field catppuccin_frappe? table
---@field nightfox? table

---@class JLine.Util
---@field themes JLine.Themes
---@field file_readonly fun(icon: string?): ''|string
---@field dimensions fun(): { integer: integer, integer: integer }

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

        if vim.bo.readonly == true and vim.bo.filetype ~= 'help' then
            return ' ' .. icon .. ' '
        end

        return ''
    end,

    themes = {
        --- Obviously works
        default = require('galaxyline.theme').default,
    },
}

if exists('tokyonight') then
    --- TODO: Works(?)
    ---@type ColorScheme|nil
    M.themes.tokyonight = require('tokyonight.colors').setup()
end

if exists('catppuccin') then
    M.themes.catppuccin_macchiato = require('catppuccin.palettes').get_palette('macchiato')
    M.themes.catppuccin_mocha = require('catppuccin.palettes').get_palette('mocha')
    M.themes.catppuccin_frappe = require('catppuccin.palettes').get_palette('frappe')
end

if exists('nightfox') then
    M.themes.nightfox = require('nightfox.palette').load()
end

---@return ColorScheme|table
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
