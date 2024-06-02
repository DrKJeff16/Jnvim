---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local Util = User.util
local types = User.types.lspconfig

local executable = Check.exists.executable
local modules = Check.exists.modules
local exists = Check.exists.module
local is_nil = Check.value.is_nil

if not modules({ 'neodev', 'lspconfig' }) or not executable({ 'lua-language-server' }) then
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
	lspconfig = true,
	pathStrict = true,
	setup_jsonls = true,
}

Neodev.setup(opts)
