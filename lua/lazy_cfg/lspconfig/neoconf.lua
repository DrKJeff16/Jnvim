---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Lspconfig = require('lspconfig')

require('user.types.lspconfig')

local User = require('user')
local exists = User.exists

if not exists('neoconf') then
	return
end

if neoconf_configured and neoconf_configured == 1 then
	return
end

_G.neoconf_configured = 1
local NC = require('neoconf')

NC.setup({

})
