---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')

local Check = require('user.check')

local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_num = Check.value.is_num
local is_bool = Check.value.is_bool

local kmap = vim.keymap.set
local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap

---@type Modes
local MODES =  { 'n', 'i', 'v', 't', 'o', 'x' }

---@type fun(mode: string|string[], func: MapFuncs, with_buf: boolean?): KeyMapFunction|ApiMapFunction|BufMapFunction
local variant = function(mode, func, with_buf)
	if is_nil(with_buf) then
		with_buf = false
	end
	local res

	local DEFAULTS = { 'noremap', 'nowait', 'silent' }

	if not with_buf then
		---@type ApiMapFunction|KeyMapFunction
		res = function(lhs, rhs, opts)
			if not is_tbl(opts) then
				opts = {}
			end

			for _, v in next, DEFAULTS do
				if not is_bool(opts[v]) then
					opts[v] = true
				end
			end

			func(mode, lhs, rhs, opts)
		end
	else
		---@type BufMapFunction
		res = function(b, lhs, rhs, opts)
			if not is_tbl(opts) then
				opts = {}
			end

			for _, v in next, DEFAULTS do
				if not is_bool(opts[v]) then
					opts[v] = true
				end
			end

			func(b, mode, lhs, rhs, opts)
		end
	end

	return res
end

---@type fun(field: 'api'|'key'|'buf'): UserKeyMaps|UserApiMaps|UserBufMaps
local mode_funcs = function(field)
	local VALID = { api = { 'map', map, false }, key = { 'kmap', kmap, false }, buf = { 'buf_map', bufmap, true } }
	if is_nil(VALID[field]) then
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
	local map_tbl = M.map

	if not is_tbl(opts) then
		opts = {}
	end

	for _, v in next, { 'nowait', 'silent' } do
		if not is_bool(opts[v]) then
			opts[v] = true
		end
	end

	opts.noremap = false

	if not is_str(mode) or not vim.tbl_contains(M.modes, mode) then
		mode = 'n'
	end

	if is_str(T) then
		map_tbl[mode](T, '<Nop>', opts)
	elseif is_tbl(T) then
		for _, v in next, T do
			map_tbl[mode](v, '<Nop>', opts)
		end
	end
end

function M.map_tbl(T, func, bufnr, mode)
	local f	= M.map

	if is_nil(mode) or not vim.tbl_contains(M.modes, mode) then
		mode = 'n'
	end
	if func == 'buf' then
		bufnr = bufnr or 0
		f = M.buf_map
	elseif func == 'key' then
		f = M.kmap
	end

	for k, v in next, T do
		if is_num(k) and is_str(v.lhs) and not is_nil(v.rhs) then
			f[mode](v.lhs, v.rhs, v.opts or {})
		elseif is_num(k) and not is_str(v[1]) and not is_nil(v[2]) then
			f[mode](v[1], v[2], v[3] or {})
		elseif is_str(k) then
			if not is_nil(v.rhs) then
				f[mode](k, v.rhs, v.opts or {})
			elseif not is_tbl(v[1]) then
				f[mode](k, v[1], v[2] or {})
			end
		else
			error('Mapping failed!')
			return
		end
	end
end

return M
