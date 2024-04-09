---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Lspconfig = require('lspconfig')

local User = require('user')
local types = User.types.lspconfig
local exists = User.exists

if not exists('neoconf') then
	return
end

if neoconf_configured and neoconf_configured == 1 then
	vim.notify('Neoconf can\'t be re-sourced.')
	return
else
	_G.neoconf_configured = 1
end

local NC = require('neoconf')

local opts = {

	-- name of the local settings files
	local_settings = ".neoconf.json",
	-- name of the global settings file in your Neovim config directory
	global_settings = "neoconf.json",
	-- import existing settings from other plugins
	import = {
		vscode = true, -- local .vscode/settings.json
		coc = false, -- global/local coc-settings.json
		nlsp = false, -- global/local nlsp-settings.nvim json settings
	},
	-- send new configuration to lsp clients when changing json settings
	live_reload = true,
	-- set the filetype to jsonc for settings files, so you can use comments
	-- make sure you have the jsonc treesitter parser installed!
	filetype_jsonc = true,
	plugins = {
		-- configures lsp clients with settings in the following order:
		-- - lua settings passed in lspconfig setup
		-- - global json settings
		-- - local json settings
		lspconfig = {
			enabled = true,
		},
		-- configures jsonls to get completion in .nvim.settings.json files
		jsonls = {
			enabled = true,
			-- only show completion in json settings for configured lsp servers
			configured_servers_only = true,
		},
		-- configures lua_ls to get completion of lspconfig server settings
		lua_ls = {
			-- by default, lua_ls annotations are only enabled in your neovim config directory
			enabled_for_neovim_config = true,
			-- explicitely enable adding annotations. Mostly relevant to put in your local .nvim.settings.json file
			enabled = true,
		},
	},
}

NC.setup(opts)
