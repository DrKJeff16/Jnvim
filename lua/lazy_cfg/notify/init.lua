---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.user.highlight

local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local hl = User.highlight.hl_from_arr

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
	minimum_width = 25,
	render = "compact",
	stages = "slide",
	time_formats = {
		notification = "%T",
		notification_history = "%FT%T"
	},
	timeout = 1500,
	top_down = false,
}

vim.notify = Notify
vim.notify.setup(Opts)

---@param msg string
---@param lvl? 'info'|'error'|'warn'
---@param opts? table
function _G.anotify(msg, lvl, opts)
	local async = require('plenary.async').run

	if not is_str(lvl) or not vim.tbl_contains({ 'info', 'warn', 'ertor' }, lvl) then
		lvl = 'warn'
	end

	if not is_tbl(opts) or not is_str(opts.title) then
		opts = {
			title = 'Attention!',
		}
	end

	async(function()
		Notify(msg, lvl, opts)
	end)
end

---@type HlPair[]
local NotifyHl = {
	{ name = 'NotifyERRORBorder', opts = { fg = '#8A1F1F' } },
	{ name = 'NotifyWARNBorder', opts = { fg = '#79491D' } },
	{ name = 'NotifyINFOBorder', opts = { fg = '#4F6752' } },
	{ name = 'NotifyDEBUGBorder', opts = { fg = '#8B8B8B' } },
	{ name = 'NotifyTRACEBorder', opts = { fg = '#4F3552' } },
	{ name = 'NotifyERRORIcon', opts = { fg = '#F70067' } },
	{ name = 'NotifyWARNIcon', opts = { fg = '#F79000' } },
	{ name = 'NotifyINFOIcon', opts = { fg = '#A9FF68' } },
	{ name = 'NotifyDEBUGIcon', opts = { fg = '#8B8B8B' } },
	{ name = 'NotifyTRACEIcon', opts = { fg = '#D484FF' } },
	{ name = 'NotifyERRORTitle', opts = {  fg = '#F70067' } },
	{ name = 'NotifyWARNTitle', opts = { fg = '#F79000' } },
	{ name = 'NotifyINFOTitle', opts = { fg = '#A9FF68' } },
	{ name = 'NotifyDEBUGTitle', opts = {  fg = '#8B8B8B' } },
	{ name = 'NotifyTRACETitle', opts = {  fg = '#D484FF' } },
	{ name = 'NotifyERRORBody', opts = { link = 'Normal' } },
	{ name = 'NotifyWARNBody', opts = { link = 'Normal' } },
	{ name = 'NotifyINFOBody', opts = { link = 'Normal' } },
	{ name = 'NotifyDEBUGBody', opts = { link = 'Normal' } },
	{ name = 'NotifyTRACEBody', opts = { link = 'Normal' } },
}

hl(NotifyHl)
