local Types = require('user_api.types') -- Source all API annotations

---@type User.Distro
---@diagnostic disable-next-line:missing-fields
local M = {}

M.archlinux = require('user_api.distro.archlinux')

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
