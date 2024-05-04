---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local types = require('user.types.user.highlight')
local Check = require('user.check')

local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl

local empty = vim.tbl_isempty

---@type UserHl
local M = {
	hl = function(name, opts)
		local hi = vim.api.nvim_set_hl

		if is_str(name) and is_tbl(opts) and not empty(opts) then
			hi(0, name, opts)
		else
			error('A highlight value is not permitted!')
		end
	end,
}

function M.hl_from_arr(arr)
	if not is_tbl(arr) or empty(arr) then
		error('Unable to parse argument.')
		return
	end

	for _, t in next, arr do
		if is_str(t.name) and is_tbl(t.opts) and not empty(t.opts) then
			M.hl(t.name, t.opts)
		else
			error('A highlight value is not permitted!')
			return
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
		error('Unable to parse argument.')
		return
	end

	for k, v in next, dict do
		if is_str(k) and is_tbl(v) and not empty(v) then
			M.hl(k, v)
		else
			error('A highlight value is not permitted!')
			return
		end
	end
end

M.current_palette = function()
	vim.cmd('colorscheme')
end

return M
