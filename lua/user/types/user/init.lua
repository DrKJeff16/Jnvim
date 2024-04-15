---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class UserSubTypes
---@field maps table
---@field highlight table
---@field autocmd table
---@field opts table
---@field check table

---@type UserSubTypes
local M = {}

M.autocmd = require('user.types.user.autocmd')
M.highlight = require('user.types.user.highlight')
M.maps = require('user.types.user.maps')
M.opts = require('user.types.user.opts')
M.check = require('user.types.user.check')

return M
