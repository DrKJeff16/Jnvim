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

local LazyDev = require('lazydev')

LazyDev.setup({
	runtime = vim.env.VIMRUNTIME --[[@as string]],

	library = {
		'luvit-meta/library',
		'Notify',
		'which_key',
		'cmp',
		'LazyDev',
		'lspconfig',
		config,
	}, ---@type string[]

	---@type boolean|(fun(root_dir):boolean?)
	enabled = function(root_dir)
		if not is_nil(vim.g.lazydev_enabled) then
			return vim.g.lazydev_enabled
		end

		return true
	end,

	-- add the cmp source for completion of:
	-- `require "modname"`
	-- `---@module "modname"`
	cmp = true,
})
