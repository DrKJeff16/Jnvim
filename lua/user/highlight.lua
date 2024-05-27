---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.highlight')
require('user.types.user.check')

---@type UserCheck
local Check = require('user.check')

local is_nil = Check.value.is_nil
local is_num = Check.value.is_num
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty

---@type UserHl
local M = {
	hl = function(name, opts, bufnr)
		if not (is_str(name) or is_tbl(opts)) or empty(name) or empty(opts) then
			error('(user.highlight.hl): A highlight value is not permitted!')
		end

		bufnr = is_int(bufnr) and bufnr or vim.api.nvim_get_current_buf()

		vim.api.nvim_set_hl(bufnr, name, opts)
	end,
}

function M.hl_from_arr(arr)
	if not is_tbl(arr) or empty(arr) then
		error('(user.highlight.hl_from_arr): Unable to parse argument.')
	end

	for _, T in next, arr do
		if (is_str(T.name) or is_tbl(T.opts)) and not empty(T.name) and not empty(T.opts) then
			M.hl(T.name, T.opts)
		else
			error('(user.highlight.hl_from_arr): A highlight value is not permitted!')
		end
	end
end

--- Set hl groups based on a dict input.
--- ---
--- Example of a valid table:
--- ```lua
--- local T = {
---		['HlGroup'] = { fg = '...', ... },
---		['HlGroupAlt'] = { ... },
--- }
--- ```
--- Which equals to:
--- ```vim
---	hi HlGroup ctermfg=... ...
---	hi HlGroupAlt ...
--- ```
---
--- See more at `:h nvim_set_hl`
function M.hl_from_dict(dict)
	if not is_tbl(dict) or empty(dict) then
		error('(user.highlight.hl_from_dict): Unable to parse argument.')
	end

	for k, v in next, dict do
		if (is_str(k) or is_tbl(v)) and not empty(v) then
			M.hl(k, v)
		else
			error('(user.highlight.hl_from_dict): A highlight value is not permitted!')
		end
	end
end

return M
