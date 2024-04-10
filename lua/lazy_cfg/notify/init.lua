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

---@param msg string
---@param lvl? 'info'|'error'|'warn'
---@param opts? table
function _G.anotify(msg, lvl, opts)
	local notify = vim.notify
	local async = require('plenary.async').run

	lvl = lvl or 'warn'
	if not vim.tbl_contains({ 'info', 'warn', 'ertor' }, lvl) then
		lvl = 'warn'
	end

	opts = opts or nil
	if opts == nil or type(opts) ~= 'table' or vim.tbl_isempty(opts) then
		opts = {
			title = 'Attention!'
		}
	end

	async(function()
		notify(msg, lvl, opts)
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
