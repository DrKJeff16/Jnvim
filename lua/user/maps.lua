---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')

local kmap = vim.keymap.set
local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap

---@type Modes
local MODES =  { 'n', 'i', 'v', 't', 'o', 'x' }

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
			if opts == nil or type(opts) ~= 'table' then
				opts = {}
			end

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
			if opts == nil or type(opts) ~= 'table' then
				opts = {}
			end

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

---@param field 'api'|'key'|'buf'
---@return UserKeyMaps|UserApiMaps|UserBufMaps res
local mode_funcs = function(field)
	local VALID = { api = { 'map', map, false }, key = { 'kmap', kmap, false }, buf = { 'buf_map', bufmap, true } }
	if VALID[field] == nil then
		error('Invalid variant ID!')
	else
		---@type UserKeyMaps|UserApiMaps|UserBufMaps
		local res = {}
		for _, mode in next, MODES do
			res[mode] = variant(mode, VALID[field][2], VALID[field][3])

		end

		return res
	end
end

---@type UserMaps
local M = {
	kmap = mode_funcs('key'),
	map = mode_funcs('api'),
	buf_map = mode_funcs('buf'),
	modes = MODES,
}

function M.nop(T, opts, mode)
	opts = opts or {}
	if mode == nil or not vim.tbl_contains(M.modes, mode) then
		mode = 'n'
	end

	if type(T) == 'string' then
		M.map[mode](T, '<Nop>', opts)
	elseif type(T) == 'table' then
		for _, v in next, T do
			M.map[mode](v, '<Nop>', opts)
		end
	end
end

function M.map_tbl(T, func, bufnr, mode)
	local f	= M.map

	if mode == nil or not vim.tbl_contains(M.modes, mode) then
		mode = 'n'
	end
	if func == 'buf' then
		bufnr = bufnr or 0
		f = M.buf_map
	elseif func == 'key' then
		f = M.kmap
	end

	for k, v in next, T do
		if type(k) == 'integer' and v.lhs ~= nil and v.rhs ~= nil then
			f[mode](v.lhs, v.rhs, v.opts or {})
		elseif type(k) == 'integer' and v[1] ~= nil and v[2] ~= nil then
			f[mode](v[1], v[2], v[3] or {})
		elseif type(k) == 'string' then
			if v.rhs ~= nil then
				f[mode](k, v.rhs, v.opts or {})
			elseif v[1] ~= nil and type(v[1]) ~= 'table' then
				f[mode](k, v[1], v[2] or {})
			end
		else
			error('Some mapping failed!')
		end
	end
end

return M
