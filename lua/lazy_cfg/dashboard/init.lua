---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require("user")
local maps_t = User.types.user.maps
local Check = User.check
local kmap = User.maps.kmap

local exists = Check.exists.module

if not exists("dashboard") then
	return
end

local DSB = require("dashboard")

local opts = {
	theme = "doom",

	disable_move = true,
	shortcut_type = "number",
	change_to_vcs_root = true,

	hide = {
		statusline = true,
		tabline = false,
		winbar = false,
	},
}

DSB.setup(opts)
