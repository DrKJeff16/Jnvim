---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local tupes = require('user.types').user.highlight
local Check = require('user.check')

---@type UserHl
local M = {
	hl = function(name, opts)
		local hi = vim.api.nvim_set_hl

		if Check.value.is_str(name) and Check.value.is_tbl(opts) then
			hi(0, name, opts)
		end
	end,
}

function M.hl_from_arr(arr)
	for _, t in next, arr do
		M.hl(t.name, t.opts)
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
	for k, v in next, dict do
		M.hl(k, v)
	end
end

M.current_palette = function()
	return vim.cmd('colorscheme')
end

return M
