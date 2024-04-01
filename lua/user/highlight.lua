---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.highlight')

local api = vim.api

local hi = api.nvim_set_hl

---@type UserHl
local M = {}

function M.hl(name, opts)
	hi(0, name, opts)
end

function M.hl_repeat(t)
	for name, opts_tbl in next, t do
		for _, opts in next, opts_tbl do
			hi(0, name, opts)
		end
	end
end

return M
