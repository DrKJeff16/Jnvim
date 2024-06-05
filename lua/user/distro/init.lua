---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Types = require('user.types') -- Source all API annotations

---@type User.Distro
local M = {
    archlinux = require('user.distro.archlinux'),
}

return M
