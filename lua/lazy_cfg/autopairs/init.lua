---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.autopairs

local exists = Check.exists.module

if not exists('nvim-autopairs') then
	return
end

local Ap = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local Conds = require('nvim-autopairs.conds')
local Handlers = require('nvim-autopairs.completion.handlers')

Ap.setup({
	active = true,
	disable_filetype = {
		"TelescopePrompt",
		"spectre_panel",
		'checkhealth',
		'help',
		'lazy',
		'NvimTree',
	},

	disable_in_macro = false,     -- disable when recording or executing a macro
	disable_in_visualblock = false, -- disable when insert after visual block mode
	disable_in_replace_mode = true,

	enable_moveright = true,
	enable_afterquote = true,      -- add bracket pairs after quote
	enable_check_bracket_line = true, --- check bracket in same line
	enable_bracket_in_quote = true,
	enable_abbr = false,           -- trigger abbreviation

	break_undo = true,             -- switch for basic rule break undo sequence

	check_ts = true,
	ts_config = {
		lua = { 'string', 'source' },
		javascript = false,
		java = false,
	},

	ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
	-- ignored_next_char = '[%w%.]',

	map_cr = true,
	map_bs = true, -- map the <BS> key
	map_c_h = false, -- Map the <C-h> key to delete a pair
	map_c_w = false, -- map <c-w> to delete a pair if possible
	map_char = {
		all = '(',
		tex = '{',
		html = '<',
		xml = '<',
	},

	-- fast_wrap = {
	-- 	map = "<M-e>",
	-- 	chars = { "{", "[", "(", '"', "'" },
	-- 	pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
	-- 	offset = 0, -- Offset from pattern match
	-- 	end_key = "$",
	-- 	keys = "qwertyuiopzxcvbnmasdfghjkl",
	-- 	check_comma = true,
	-- 	highlight = "Search",
	-- 	highlight_grey = "Comment",
	-- },
})

---@type APMods
local M = {
	cmp = function()
		return exists('lazy_cfg.autopairs.cmp', true) or nil
	end,
	rules = function()
		return exists('lazy_cfg.autopairs.rules', true)
	end,
}

M.rules()

local ap_cmp = M.cmp()
ap_cmp.on()
