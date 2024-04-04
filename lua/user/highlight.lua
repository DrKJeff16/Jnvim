---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.highlight')

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

function M.hl_from_dict(dict)
	for k, v in next, dict do
		hi(0, k, v)
	end
end

function M.hl_repeat(t)
	for name, opts_arr in next, t do
		for _, opts in next, opts_arr do
			hi(0, name, opts)
		end
	end
end

return M
