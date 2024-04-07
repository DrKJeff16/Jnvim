---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.highlight')

local User = require('user')
local exists = User.exists

if not exists('notify') then
	return
end

local Notify = require('notify')

---@type notify.Config
local Opts = {
	background_colour = 'NotifyBackground',
	fps = 30,
	icons = {
		DEBUG = "",
		ERROR = "",
		INFO = "",
		TRACE = "✎",
		WARN = ""
	},
	level = 2,
	minimum_width = 15,
	render = "default",
	stages = "fade_in_slide_out",
	time_formats = {
		notification = "%T",
		notification_history = "%FT%T"
	},
	timeout = 1250,
	top_down = true,
}

Notify.setup(Opts)

vim.notify = Notify
