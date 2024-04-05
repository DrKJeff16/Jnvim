---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.lazy')

local fn = vim.fn
local set = vim.o
local opt = vim.opt
local g = vim.g

local exists = fn.exists
local has = fn.has

local Lazy = require('lazy')
local Util = require('lazy.util')

---@type LazyConfig
local M = {
	defaults = {
		lazy = false,  -- WARN: DO NOT TOUCH.
		version = '*',
	},
	ui = {
		size = {
			width = 0.75,
			height = 0.75,
		},
		wrap = set.wrap,
		border = exists('+termguicolors') == 1 and 'double' or 'none',
		backdrop = 55,  -- Opacity
		title = 'LAZY',
		title_pos = 'center',
		pills = true,

		browser = nil,

		-- TODO: Define `<localleader>` mappings.
		custom_keys = {},
	},
}

return M
