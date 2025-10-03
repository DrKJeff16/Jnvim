local User = require('user_api')
local Check = User.check

local in_list = vim.list_contains

local exists = Check.exists.module
if not exists('alpha') then
    return nil
end

local Alpha = require('alpha')

---@class AlphaCaller
local M = {}

function M.theta()
    local Theta = require('alpha.themes.theta')
    Theta.header = {
        type = 'text',
        val = {
            [[      _            _ ]],
            [[     | |_ ____   _(_)_ __ ___  ]],
            [[  _  | |  _ \ \ / / |  _   _ \  ]],
            [[ | | | | | | | V /| | | | | | | ]],
            [[  \___/|_| |_|\_/ |_|_| |_| |_| ]],
        },
        opts = {
            position = 'center',
            hl = 'Type',
            wrap = 'overflow',
        },
    }
    Theta.config.layout[2] = Theta.header
    Theta.file_icons.provider = 'mini'
    Alpha.setup(Theta.config)
end

function M.startify()
    local Startify = require('alpha.themes.startify')
    Startify.file_icons.provider = 'mini'
    Alpha.setup(Startify.config)
end

function M.dashboard()
    local Dashboard = require('alpha.themes.dashboard')
    Alpha.setup(Dashboard.config)
end

---@return AlphaCaller|fun(variant?: 'theta'|'dashboard'|'startify')
function M.new()
    return setmetatable({}, {
        __index = M,

        ---@param self AlphaCaller
        ---@param variant? 'theta'|'dashboard'|'startify'
        __call = function(self, variant)
            if vim.fn.has('nvim-0.11') == 1 then
                vim.validate('variant', variant, 'string', true, "'theta'|'dashboard'|'startify'")
            else
                vim.validate({ variant = { variant, { 'string', 'nil' } } })
            end
            variant = variant or 'theta'

            if not in_list({ 'theta', 'dashboard', 'startify' }, variant) then
                variant = 'theta'
            end

            ---@type fun()
            local func = self[variant]
            func()
        end,
    })
end

return M.new()
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
