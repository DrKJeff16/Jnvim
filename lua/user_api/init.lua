---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Types = require('user_api.types') ---@see User.Types
local Check = require('user_api.check') ---@see User.Check
local Util = require('user_api.util') ---@see User.Util

---@type User
local M = {
    types = require('user_api.types'),
    util = require('user_api.util'),
    check = require('user_api.check'),
    maps = require('user_api.maps'),
    highlight = require('user_api.highlight'),
    opts = require('user_api.opts'),
    distro = require('user_api.distro'),
    update = require('user_api.update'),
    commands = require('user_api.commands'):new(),
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
