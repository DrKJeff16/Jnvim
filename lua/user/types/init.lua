---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class UserTypes
---@field user UserSubTypes
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
---@field toggleterm table
---@field treesitter table
---@field which_key table

---@class UserOpts

--- Table of mappings for each mode `(normal|insert|visual|terminal|...)`.
--- Each mode contains its respective mappings.
--- `map_tbl.[n|i|v|t|o|x]['<YOUR_KEY>'].opts` a `vim.keymap.set.Opts` table.
---@alias Maps table<'n'|'i'|'v'|'t'|'o'|'x', table<string, KeyMapRhsOptsArr>>

---@class UserMod
---@field check UserCheck
---@field maps UserMaps
---@field highlight UserHl
---@field opts UserOpts
---@field types UserTypes
---@field util UserUtils

---@type UserTypes
local M = {
	--- API-related annotations
	user = require('user.types.user'),

	--- Plugin config-related annotations below

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
	toggleterm = require('user.types.toggleterm'),
	treesitter = require('user.types.treesitter'),
	which_key = require('user.types.which_key'),
}

return M
