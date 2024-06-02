---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local Util = User.util
local types = User.types.lspconfig

local executable = Check.exists.executable
local exists = Check.exists.module
local is_nil = Check.value.is_nil

if not exists('lazydev') or not executable('lua-language-server') then
	return
end

local stdpath = vim.fn.stdpath

local config = stdpath('config')
local LAZY = vim.env.LAZY

local LazyDev = require('lazydev')

LazyDev.setup({
	runtime = vim.env.VIMRUNTIME --[[@as string]],

	library = {
		LAZY .. '/luvit-meta/library',
		LAZY .. '/Notify',
		LAZY .. '/which_key',
		LAZY .. '/cmp',
		LAZY .. '/LazyDev',
		LAZY .. '/lspconfig',
		config,
	}, ---@type string[]

	---@type boolean|(fun(client:vim.lsp.Client):boolean?)
	enabled = function(client)
		if not is_nil(vim.g.lazydev_enabled) then
			return vim.g.lazydev_enabled
		end

		return client.root_dir and vim.uv.fs_stat(client.root_dir .. '/lua') and true or false
	end,

	-- add the cmp source for completion of:
	-- `require "modname"`
	-- `---@module "modname"`
	cmp = true,
})
