---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local types = User.types
local csc_m = types.colorschemes
local exists = User.check.exists.module

---@param subs string[]
---@return CscMod
local src = function(subs)
	---@type CscMod
	local res = {}
	for _, v in next, subs do
		local path = 'lazy_cfg.colorschemes.'..v
		if exists(path) then
			res[v] = require(path)
		end
	end

	return res
end

local submods = {
	'tokyonight',
	'catppuccin',
	'nightfox',
	'spaceduck',
	'dracula',
	'gloombuddy',
}

local M = src(submods)

return M
