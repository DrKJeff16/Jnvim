---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local exists = User.exists

if not exists('scope') then
	return
end

local Scope = require('scope')

local opts = {}

Scope.setup(opts)
