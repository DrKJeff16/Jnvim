---@diagnostic disable:missing-fields

---@module 'user_api.types.distro'

local INFO = vim.log.levels.INFO

---@type User.Distro|fun()
local Distro = {}

---@type User.Distro.Archlinux
Distro.archlinux = require('user_api.distro.archlinux')

---@type User.Distro.Termux
Distro.termux = require('user_api.distro.termux')

---@param O? table
---@return table|User.Distro|fun(verbose: boolean?)
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

            if self.termux:validate() then
                self.termux:setup()
                msg = 'Termux distribution detected...'
            elseif self.archlinux:validate() then
                self.archlinux:setup()
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
