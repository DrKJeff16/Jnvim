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
local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---@type fun(mode: string|string[], func: MapFuncs, with_buf: boolean?): KeyMapFunction|ApiMapFunction|BufMapFunction
local variant = function(mode, func, with_buf)
	if not is_bool(with_buf) then
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
	if not (is_str(T) or is_tbl(T)) then
		return
	end

	local map_tbl = M.map

	if not is_str(mode) or not vim.tbl_contains(M.modes, mode) then
		mode = 'n'
	elseif mode == 'i' then
		return
	end

	if not is_tbl(opts) then
		opts = {}
	end

	for _, v in next, { 'nowait', 'noremap' } do
		if not is_bool(opts[v]) then
			opts[v] = false
		end
	end

	if not is_bool(opts.silent) then
		opts.silent = true
	end

	if is_str(T) then
		map_tbl[mode](T, '<Nop>', opts)
	elseif is_tbl(T) then
		for _, v in next, T do
			map_tbl[mode](v, '<Nop>', opts)
		end
	else
		error('(user.maps.nop): Unable to parse keys.')
		return
	end
end

return M
