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
	'nightfox',
	'tokyonight',
	'catppuccin',
	'gloombuddy',
	'spaceduck',
	'dracula',
}

return src(submods)
