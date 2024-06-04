---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Types = require('user.types') -- Source all API annotations
local Check = require('user.check') -- Checker utilities
local Util = require('user.util') -- Coding utilities

local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local is_int = Check.value.is_int
local is_str = Check.value.is_str
local empty = Check.value.empty

---@type UserMod
local M = {
	types = require('user.types'),
	util = require('user.util'),
	check = require('user.check'),
	maps = require('user.maps'),
	highlight = require('user.highlight'),
	opts = require('user.opts'),
	distro = require('user.distro'),
	update = require('user.update'),

	---@deprecated
	assoc = Util.assoc,
}

return M
