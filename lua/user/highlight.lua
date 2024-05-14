---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local types = require('user.types.user.highlight')
local Check = require('user.check')

local is_nil = Check.value.is_nil
local is_num = Check.value.is_num
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty

---@type UserHl
local M = {
	hl = function(name, opts, bufnr)
		if not (is_str(name) or is_tbl(opts)) or empty(name) or empty(opts) then
			error('A highlight value is not permitted!')
			return
		end

		if not is_num(bufnr) or bufnr < 0 then
			bufnr = 0
		end

		vim.api.nvim_set_hl(bufnr, name, opts)
	end,
	current_palette = function()
		vim.cmd('colorscheme')
	end,
}

function M.hl_from_arr(arr)
	if not is_tbl(arr) or empty(arr) then
		error('Unable to parse argument.')
		return
	end

	for _, T in next, arr do
		if not (is_str(T.name) or is_tbl(T.opts)) or empty(T.name) or empty(T.opts) then
			error('A highlight value is not permitted!')
			return
		end

		M.hl(T.name, T.opts)
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
		error('Unable to parse argument.')
		return
	end

	for k, v in next, dict do
		if not (is_str(k) or is_tbl(v)) or empty(v) then
			error('A highlight value is not permitted!')
			return
		end

		M.hl(k, v)
	end
end

return M
