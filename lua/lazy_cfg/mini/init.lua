---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun

---@param mini_mod string
---@param opts table
local function src(mini_mod, opts)
	mini_mod = 'mini.' .. mini_mod
	if not exists(mini_mod) then
		return
	end

	local M = require(mini_mod)

	if not is_tbl(opts) then
		opts = {}
	end

	if is_fun(M.setup) then
		M.setup(opts)
	end
end

---@alias MiniModules table<string, table>

---@type MiniModules
local modules = {
	-- ['basics'] = {},
	['cursorword'] = {},
	['doc'] = {},
	['hipatterns'] = {},
	['trailspace'] = {},
}

for mod, opts in next, modules do
	src(mod, opts)
end
