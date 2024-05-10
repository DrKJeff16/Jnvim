---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class UserPlugTmpl

---@class UserCmp: UserPlugTmpl
---@class UserNotify: UserPlugTmpl

---@class UserPlugin
---@field cmp? UserCmp
---@field notify? UserNotify

---@class UserTypes
---@field autopairs table
---@field cmp table
---@field colorizer table
---@field colorschemes table
---@field comment table
---@field gitsigns table
---@field lazy table
---@field lspconfig table
---@field lualine table
---@field mini table
---@field notify table
---@field nvim_tree table
---@field telescope table
---@field todo_comments table
---@field treesitter table
---@field user UserSubTypes
---@field which_key table

---@class UserOpts

---@class UserMod
---@field check UserCheck
---@field assoc fun()
---@field maps UserMaps
---@field highlight UserHl
---@field opts UserOpts
---@field types UserTypes

---@type UserTypes
local M = {
	autopairs = require('user.types.autopairs'),
	colorizer = require('user.types.colorizer'),
	colorschemes = require('user.types.colorschemes'),
	cmp = require('user.types.cmp'),
	comment = require('user.types.comment'),
	gitsigns = require('user.types.gitsigns'),
	lazy = require('user.types.lazy'),
	lspconfig = require('user.types.lspconfig'),
	lualine = require('user.types.lualine'),
	mini = require('user.types.mini'),
	notify = require('user.types.notify'),
	nvim_tree = require('user.types.nvim_tree'),
	telescope = require('user.types.telescope'),
	todo_comments = require('user.types.todo_comments'),
	treesitter = require('user.types.treesitter'),
	which_key = require('user.types.which_key'),

	user = require('user.types.user'),
}

return M
