---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Types = require('user.types') -- Source all API annotations

---@type User.Distro
local M = {
    archlinux = require('user.distro.archlinux'),
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
