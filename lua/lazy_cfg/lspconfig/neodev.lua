---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local modules = Check.exists.modules
local executable = Check.exists.executable
local types = User.types.lspconfig

if not modules({ 'neodev', 'lspconfig' }) or not executable({
	'lua-language-server',
	'vscode-json-language-server'
}) then
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
