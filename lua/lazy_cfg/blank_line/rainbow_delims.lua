---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.highlight')

local User = require('user')
local exists = User.exists
local hi = User.highlight().hl

local Bl = require('rainbow-delimiters')
local Ibl = require('ibl')
local hooks = require('ibl.hooks')

---@class BlCfgMod
---@field setup? fun(hilites: string[]?, opts: table?): any
local M = {}

function M.setup(hilites, opts)
	opts = opts or require('rainbow-delimiters.types')

	return Bl.setup()
end

return M
