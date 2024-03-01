---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

local api = vim.api

local hi = api.nvim_set_hl

local Mod = 'lazy_cfg.blank_line.rainbow_delims'
local Bl = require('rainbow-delimiters')

Ibl = require('ibl')
local hooks = require('ibl.hooks')

---@class BlCfgMod
---@field default table<string[]>
local M = {
	default = {
		hlts = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		},
	},

	---@param hilites? string[]
	---@param opts? table
	setup = function(hilites, opts)
		hilites = hilites or self.default.hlts
		if not opts or not type(opts) == 'table' or #opts == 0 then
			opts = require('rainbow-delimiters.types')
		end

		return Bl.setup()
	end,
}

return M
