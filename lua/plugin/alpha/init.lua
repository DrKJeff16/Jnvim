---@diagnostic disable:missing-fields

---@alias AlphaFun fun(variant: ('dashboard'|'theta'|'startify')?)

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl

local in_tbl = vim.tbl_contains

if not exists('alpha') then
    return nil
end

local Alpha = require('alpha')

---@class AlphaCaller
local M = {}

function M.theta()
    local Theta = require('alpha.themes.theta')

    if exists('nvim-web-devicons') then
        ---@type 'mini'|'devicons'
        Theta.file_icons.provider = 'devicons'
    end

    Alpha.setup(Theta.config)
end

function M.startify()
    local Startify = require('alpha.themes.startify')

    if exists('nvim-web-devicons') then
        ---@type 'mini'|'devicons'
        Startify.file_icons.provider = 'devicons'
    end

    Alpha.setup(Startify.config)
end

function M.dashboard()
    local Dashboard = require('alpha.themes.dashboard')

    Alpha.setup(Dashboard.config)
end

---@param O? table
---@return table|AlphaCaller|AlphaFun
function M.new(O)
    O = is_tbl(O) and O or {}

    return setmetatable(O, {
        __index = M,

        ---@param self AlphaCaller
        ---@param variant? 'theta'|'dashboard'|'startify'
        __call = function(self, variant)
            if not (is_str(variant) and in_tbl({ 'theta', 'dashboard', 'startify' }, variant)) then
                variant = 'startify'
            end

            ---@type fun(...: any)
            local fun = self[variant]

            fun()
        end,
    })
end

User.register_plugin('plugin.alpha')

return M.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
