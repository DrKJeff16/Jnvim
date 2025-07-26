---@diagnostic disable:missing-fields

---@alias User.Distro.CallerFun fun(verbose: boolean?)

local INFO = vim.log.levels.INFO

---@class User.Distro
---@field archlinux table|User.Distro.Archlinux|User.Distro.Archlinux.CallerFun
---@field termux table|User.Distro.Termux|User.Distro.Termux.CallerFun
---@field new fun(O: table?): table|User.Distro|User.Distro.CallerFun
local Distro = {}

Distro.archlinux = require('user_api.distro.archlinux')
Distro.termux = require('user_api.distro.termux')

---@param O? table
---@return table|User.Distro|User.Distro.CallerFun
function Distro.new(O)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl
    local is_bool = Value.is_bool

    O = is_tbl(O) and O or {}

    return setmetatable(O, {
        __index = Distro,

        ---@param self User.Distro
        ---@param verbose? boolean
        __call = function(self, verbose)
            verbose = is_bool(verbose) and verbose or false

            local msg = ''

            if self.termux.validate() then
                self.termux()
                msg = 'Termux distribution detected...'
            elseif self.archlinux.validate() then
                self.archlinux()
                msg = 'Arch Linux distribution detected...'
            end

            if verbose then
                vim.notify(msg, INFO)
            end
        end,
    })
end

return Distro.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
