---@meta

---@class UserSubTypes
---@field maps nil
---@field highlight nil
---@field autocmd nil
---@field opts nil
---@field check nil
---@field util nil
---@field update nil

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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
