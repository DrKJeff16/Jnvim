---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')

local api = vim.api
local keymap = vim.keymap

local kmap = keymap.set
local map = api.nvim_set_keymap
local bufmap = api.nvim_buf_set_keymap

---@alias MapFuncs fun(lhs: string|string[], rhs: string|fun(), opts:(ApiMapOpts|KeyMapOpts)?)|fun(bufnr: integer, lhs: string, rhs: string, opts: ApiMapOpts?)

---@param mode string|string[]
---@param func MapFuncs
---@param with_buf? boolean
---@return KeyMapFunction|ApiMapFunction|BufMapFunction
local variant = function(mode, func, with_buf)
	if with_buf == nil then
		with_buf = false
	end
	local res

	local DEFAULTS = { 'noremap', 'nowait', 'silent' }

	if not with_buf then
		---@type ApiMapFunction|KeyMapFunction
		res = function(lhs, rhs, opts)
			opts = opts or {}

			for _, v in next, DEFAULTS do
				if opts[v] == nil then
					opts[v] = true
				end
			end

			func(mode, lhs, rhs, opts)
		end
	else
		---@type BufMapFunction
		res = function(b, lhs, rhs, opts)
			opts = opts or {}

			for _, v in next, DEFAULTS do
				if opts[v] == nil then
					opts[v] = true
				end
			end

			func(b, mode, lhs, rhs, opts)
		end
	end

	return res
end

---@type UserMaps
local M = {
	kmap = {
		n = variant('n', kmap),
		i = variant('i', kmap),
		v = variant('v', kmap),
		t = variant('t', kmap),
		o = variant('o', kmap),
		x = variant('x', kmap),
	},
	map = {
		n = variant('n', map),
		i = variant('i', map),
		v = variant('v', map),
		t = variant('t', map),
		o = variant('o', map),
		x = variant('x', map),
	},
	buf_map = {
		n = variant('n', bufmap, true),
		i = variant('i', bufmap, true),
		v = variant('v', bufmap, true),
		t = variant('t', bufmap, true),
		o = variant('o', bufmap, true),
		x = variant('x', bufmap, true),
	},
}

return M
