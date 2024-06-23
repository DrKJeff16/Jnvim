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

---@class JLine.Util
---@field themes table<string, table|nil>
---@field file_readonly fun(icon: string?): ''|string
---@field dimensions fun(): { integer: integer, integer: integer }

---@type JLine.Util
---@diagnostic disable-next-line:missing-fields
local M = {
    themes = {
        --- Obviously works
        default = require('galaxyline.theme').default,

        --- TODO: Works(?)
        tokyonight = exists('tokyonight.colors') and require('tokyonight.colors').default or nil,

        --- FIX: Doesn't work
        catppuccin_mocha = exists('catppuccin.palettes.mocha') and require('catppuccin.palettes.mocha') or nil,
        catppuccin_frappe = exists('catppuccin.palettes.frappe') and require('catppuccin.palettes.frappe') or nil,
        catppuccin_macchiato = exists('catppuccin.palettes.macchiato') and require('catppuccin.palettes.macchiato')
            or nil,

        --- FIX: Doesn't work
        nightfox = require('nightfox.palette.carbonfox').palette,
    },

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
}

function M:palette()
    return self.themes[self.variant]
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
