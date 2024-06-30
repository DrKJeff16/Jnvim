---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Types = require('user.types') ---@see User.Types
local Check = require('user.check') ---@see User.Check
local Util = require('user.util') ---@see User.Util

---@type User
local M = {
    types = require('user.types'),
    util = require('user.util'),
    check = require('user.check'),
    maps = require('user.maps'),
    highlight = require('user.highlight'),
    opts = require('user.opts'),
    distro = require('user.distro'),
    update = require('user.update'),
    commands = require('user.commands'):new(),
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
