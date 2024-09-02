require('user_api.types')

---@type User.Distro
---@diagnostic disable-next-line:missing-fields
local M = {}

M.archlinux = require('user_api.distro.archlinux')
M.termux = require('user_api.distro.termux')

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
