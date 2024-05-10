---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module

---@param subs string[]
---@return CscMod
local src = function(subs)
	---@type CscMod
	local res = {}

	for _, v in next, subs do
		local path = 'lazy_cfg.colorschemes.'..v
		res[v] = exists(path, true) or nil
	end

	return res
end

local submods = {
	'tokyonight',
	'catppuccin',
	'nightfox',
	'gloombuddy',
	'spaceduck',
	'dracula',
	'molokai',
}

local M = src(submods)
function M.new()
	local self = setmetatable({}, { __index = M })

	self.new = M.new
	self.nightfox = M.nightfox or nil
	self.tokyonight = M.tokyonight or nil
	self.catppuccin = M.catppuccin or nil
	self.gloombuddy = M.gloombuddy or nil
	self.spaceduck = M.spaceduck or nil
	self.dracula = M.dracula or nil
	self.molokai = M.molokai or nil

	return self
end

return M
