---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local tupes = require('user.types').user.highlight

local hi = vim.api.nvim_set_hl

---@type UserHl
local M = {}

function M.hl(name, opts)
	hi(0, name, opts)
end

function M.hl_from_arr(arr)
	for _, t in next, arr do
		hi(0, t.name, t.opts)
	end
end

--- Set hl groups based on u.
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
--- See more at `:h nvim_set_hl`
function M.hl_from_dict(dict)
	for k, v in next, dict do
		hi(0, k, v)
	end
end

M.current_palette = function()
	return vim.cmd('colorscheme')
end

return M
