---@diagnostic disable:missing-fields

---@module 'user_api.types.distro'

---@type User.Distro
local Distro = {}

---@type User.Distro.Archlinux
Distro.archlinux = require('user_api.distro.archlinux')

---@type User.Distro.Termux
Distro.termux = require('user_api.distro.termux')

---@param self User.Distro
function Distro:setup()
    local archlinux = self.archlinux
    local termux = self.termux

    if termux:validate() then
        termux:setup()
    elseif archlinux:validate() then
        archlinux:setup()
    end
end

return Distro

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
