---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists
local hl = User.highlight.hl_from_arr
local types = User.types.user.highlight

if not exists('notify') then
	return
end

local Notify = require('notify')

---@type notify.Config
local Opts = {
	background_colour = 'NotifyBackground',
	fps = 48,
	icons = {
		DEBUG = "",
		ERROR = "",
		INFO = "",
		TRACE = "✎",
		WARN = ""
	},
	level = 2,
	minimum_width = 20,
	render = "compact",
	stages = "slide",
	time_formats = {
		notification = "%T",
		notification_history = "%FT%T"
	},
	timeout = 1000,
	top_down = false,
}

Notify.setup(Opts)

vim.notify = Notify
