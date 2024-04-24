---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.check.exists.module

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
		'markdown',
		'gitconfig',
		'text',
	},

	disable_in_macro = false,  -- disable when recording or executing a macro
	disable_in_visualblock = true,  -- disable when insert after visual block mode
	disable_in_replace_mode = true,

	enable_moveright = true,
	enable_afterquote = true,  -- add bracket pairs after quote
	enable_check_bracket_line = true,  --- check bracket in same line
	enable_bracket_in_quote = false,  --
	enable_abbr = false,  -- trigger abbreviation

	break_undo = true,  -- switch for basic rule break undo sequence

	check_ts = true,
	ts_config = {
		lua = {'string', 'source'},
		javascript = false,
		java = false,
	},

	ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
	-- ignored_next_char = '[%w%.]',

	map_cr = true,
	map_bs = true,  -- map the <BS> key
	-- map_c_h = false,  -- Map the <C-h> key to delete a pair
	map_c_w = true,  -- map <c-w> to delete a pair if possible
	map_char = {
		all = '(',
		tex = '{',
		lua = '{',
	},

	fast_wrap = {
		map = "<M-e>",
		chars = { "{", "[", "(", '"', "'" },
		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
		offset = 0, -- Offset from pattern match
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "Search",
		highlight_grey = "Comment",
    },
})

local ts_conds = require('nvim-autopairs.ts-conds')
Ap.add_rules({
	Rule("%", "%", "lua")
    :with_pair(ts_conds.is_ts_node({'string','comment'})),
	Rule("$", "$", "lua")
	:with_pair(ts_conds.is_not_ts_node({'function'}))
})

---@alias FilterTbl table<string, string>|string[]

---@class AP
---@field cmp? table
---@field rules? any
local M = {}

---@param subms string[] The submodule string array.
---@return FilterTbl res
local sub_filter = function(subms)
	local prefix = 'lazy_cfg.autopairs.'

	---@type FilterTbl
	local res = {}

	for _, v in ipairs(subms) do
		if prefix ~= nil then
			local path = prefix..v
			if exists(path) then
				res[v] = path
			end
		elseif exists(v) then
			table.insert(res, v)
		end
	end

	return res
end

---@type string[]
local submods = {
	'rules',
	'cmp',
}

for _, v in next, sub_filter(submods) do
	require(v)
end

return M
