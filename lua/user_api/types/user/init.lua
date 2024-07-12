---@class UserSubTypes
---@field maps table
---@field highlight table
---@field autocmd table
---@field opts table
---@field check table
---@field util table
---@field update table

---@type UserSubTypes
local M = {
    autocmd = require('user_api.types.user.autocmd'),
    check = require('user_api.types.user.check'),
    highlight = require('user_api.types.user.highlight'),
    maps = require('user_api.types.user.maps'),
    opts = require('user_api.types.user.opts'),
    util = require('user_api.types.user.util'),
    update = require('user_api.types.user.update'),
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
