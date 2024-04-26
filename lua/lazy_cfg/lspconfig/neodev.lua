---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.lspconfig

local executable = Check.exists.executable
local modules = Check.exists.modules
local exists = Check.exists.module

if not modules({ 'neodev', 'lspconfig' }) or not executable({
	'lua-language-server',
	'vscode-json-language-server'
}) then
	local msg = [[Missing any of the following:
	- `neodev`
	- `lspconfig`
	- `lua-language-server`
	- `vscode-json-language-server`
	]]
	if exists('notify') then
		require('notify')(msg, 'error')
	else
		error(msg)
	end
	return
end

local Neodev = require('neodev')
---@type LuaDevOptions
local opts = {
	library = {
		enabled = true,
		runtime = true,
		types = true,
		plugins = true,
	},
	setup_jsonls = true,
	lspconfig = true,
	pathStrict = true,
}

Neodev.setup(opts)
