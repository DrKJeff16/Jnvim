---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')
require('user.types.user.check')

---@type UserCheck
local Check = require('user.check')

local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_num = Check.value.is_num
local is_int = Check.value.is_int
local is_bool = Check.value.is_bool
local empty = Check.value.empty

local kmap = vim.keymap.set
local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap

---@type Modes
local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---@type fun(mode: string, func: MapFuncs, with_buf: boolean?): KeyMapFunction|ApiMapFunction|BufMapFunction
local function variant(mode, func, with_buf)
	if not (is_fun(func) and is_str(mode) and vim.tbl_contains(MODES, mode)) then
		error('(user.maps.variant): Argument of incorrect type.')
	end

	with_buf = is_bool(with_buf) and with_buf or false

	---@type KeyMapFunction|ApiMapFunction|BufMapFunction
	local res

	local DEFAULTS = { 'noremap', 'nowait', 'silent' }

	if not with_buf then
		---@type ApiMapFunction|KeyMapFunction
		res = function(lhs, rhs, opts)
			opts = is_tbl(opts) and opts or {}

			for _, v in next, DEFAULTS do
				opts[v] = is_bool(opts[v]) and opts[v] or true
			end

			func(mode, lhs, rhs, opts)
		end
	else
		---@type BufMapFunction
		res = function(b, lhs, rhs, opts)
			opts = is_tbl(opts) and opts or {}

			for _, v in next, DEFAULTS do
				opts[v] = is_bool(opts[v]) and opts[v] or true
			end

			func(b, mode, lhs, rhs, opts)
		end
	end

	return res
end

---@type fun(field: 'api'|'key'|'buf'): UserKeyMaps|UserApiMaps|UserBufMaps
local mode_funcs = function(field)
	---@type table<'api'|'key'|'buf', { integer: fun(...), integer: boolean }>
	local VALID = { api = { map, false }, key = { kmap, false }, buf = { bufmap, true } }

	if is_nil(VALID[field]) then
		error('(user.maps:mode_funcs): Invalid variant ID `' .. field .. "`\nMust be `'api'|'key'|'buf'`")
	end

	---@type UserKeyMaps|UserApiMaps|UserBufMaps
	local res = {}

	for _, mode in next, MODES do
		res[mode] = variant(mode, VALID[field][1], VALID[field][2])
	end

	return res
end

---@type UserMaps
local M = {
	kmap = mode_funcs('key'),
	map = mode_funcs('api'),
	buf_map = mode_funcs('buf'),
	modes = MODES,
}

function M.kmap.desc(msg, silent, bufnr, noremap, nowait)
	return {
		desc = (is_str(msg) and not empty(msg)) and msg or 'Unnamed Key',
		silent = is_bool(silent) and silent or true,
		buffer = is_int(bufnr) and bufnr or 0,
		noremap = is_bool(noremap) and noremap or true,
		nowait = is_bool(nowait) and nowait or true,
	}
end
for _, field in next, { M.map, M.buf_map } do
	function field.desc(msg, silent, noremap, nowait)
		return {
			desc = (is_str(msg) and not empty(msg)) and msg or 'Unnamed Key',
			silent = is_bool(silent) and silent or true,
			noremap = is_bool(noremap) and noremap or true,
			nowait = is_bool(nowait) and nowait or true,
		}
	end
end

function M.nop(T, opts, mode)
	if not (is_str(T) or is_tbl(T)) then
		error('(user.maps.nop): Field is neither a string nor a table.')
	end

	local map_tbl = M.map

	mode = (is_str(mode) and vim.tbl_contains(M.modes, mode)) and mode or 'n'
	if mode == 'i' then
		return
	end

	opts = is_tbl(opts) and opts or {}

	for _, v in next, { 'nowait', 'noremap' } do
		opts[v] = is_bool(opts[v]) and opts[v] or false
	end

	opts.silent = is_bool(opts.silent) and opts.silent or true

	if is_str(T) then
		map_tbl[mode](T, '<Nop>', opts)
	else
		for _, v in next, T do
			map_tbl[mode](v, '<Nop>', opts)
		end
	end
end

return M
