---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
local User = require('user')
local exists = User.exists

local mod = "nvim-autopairs"
if not exists(mod) then
	return
end

local pfix = 'lazy_cfg.autopairs.'

local Rule = require('nvim-autopairs.rule')
local Ap = require('nvim-autopairs')
local Conds = require('nvim-autopairs.conds')
local Handlers = require('nvim-autopairs.completion.handlers')

Ap.setup({
	active = true,
	disable_filetype = {
		"TelescopePrompt",
		"spectre_panel",
		'checkhealth',
		'help',
	},
	
	disable_in_macro = false,  -- disable when recording or executing a macro
	disable_in_visualblock = false,  -- disable when insert after visual block mode
	disable_in_replace_mode = true,
	
	enable_moveright = true,
	enable_afterquote = true,  -- add bracket pairs after quote
	enable_check_bracket_line = false,  --- check bracket in same line
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
	map_c_w = false,  -- map <c-w> to delete a pair if possible
	map_char = {
		all = '(',
		tex = '{',
		bash = '{',
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

---@alias str_arr string[]
---@alias dict {[string]:string}
---@alias filter_ret dict|str_arr

---@class APMod
local M = {}

---@param subms str_arr The submodule string array.
---@param pfx? string The module's prefix path in case they aren't already joined in `subms`.
---@return filter_ret res
local sub_filter = function(subms, pfx)
	local cond = pfx and type(pfx) == 'string'
	pfx = cond and pfx or nil

	local res = {}

	local full_path
	for _, v in ipairs(subms) do
		if pfx ~= nil then
			full_path = pfx..v
			if exists(full_path) then
				res[v] = full_path
			end
		elseif exists(v) then
			table.insert(res, v)
		end
	end

	return res
end

---@type str_arr
local submods = {
	'rules',
	'cmp',
}

for k, v in next, sub_filter(submods, pfix) do
	require(v)
end

return M
