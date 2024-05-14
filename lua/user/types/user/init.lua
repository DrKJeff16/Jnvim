---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class UserSubTypes
---@field maps table
---@field highlight table
---@field autocmd table
---@field opts table
---@field check table

---@type UserSubTypes
local M = {
	autocmd = require('user.types.user.autocmd'),
	check = require('user.types.user.check'),
	highlight = require('user.types.user.highlight'),
	maps = require('user.types.user.maps'),
	opts = require('user.types.user.opts'),
}

return M
