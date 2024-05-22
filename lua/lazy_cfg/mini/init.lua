---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.mini

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun

---@type fun(min_mod: string, opts: table?)
local function src(mini_mod, opts)
	mini_mod = 'mini.' .. mini_mod

	if not exists(mini_mod) then
		error('(lazy_cfg.mini:src): Unable to import `' .. mini_mod .. '`')
	end

	local M = require(mini_mod)

	opts = is_tbl(opts) and opts or {}

	if is_fun(M.setup) then
		M.setup(opts)
	end
end

---@type MiniModules
local modules = {
	['basics'] = {},
	['cursorword'] = {},
	['doc'] = {},
	['hipatterns'] = {},
	['trailspace'] = {},
}

for mod, opts in next, modules do
	src(mod, opts)
end
