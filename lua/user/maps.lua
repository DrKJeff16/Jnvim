---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

require('user.types.user.maps')

local Check = require('user.check')

local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_num = Check.value.is_num
local is_int = Check.value.is_int
local is_bool = Check.value.is_bool
local empty = Check.value.empty
local field = Check.value.field

local kmap = vim.keymap.set
local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap

---@type Modes
local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---@type fun(T: UserMaps.Api.Opts|UserMaps.Keymap.Opts|UserMaps.Buf.Opts, fields: string|string[]): UserMaps.Api.Opts|UserMaps.Keymap.Opts|UserMaps.Buf.Opts
local strip_options = function(T, fields)
	if not is_tbl(T) then
		error('(maps:strip_options): Empty table')
	end

	if empty(T) then
		return T
	end

	if not (is_str(fields) or is_tbl(fields)) or empty(fields) then
		return T
	end

	---@type UserMaps.Keymap.Opts
	local res = {}

	if is_str(fields) then
		if not field(fields, T) then
			return T
		end

		for k, v in next, T do
			if k ~= fields then
				res[k] = v
			end
		end
	else
		for k, v in next, T do
			if not vim.tbl_contains(fields, k) then
				res[k] = v
			end
		end
	end

	return res
end

---@type fun(mode: string, func: MapFuncs, with_buf: boolean?): KeyMapFunction|ApiMapFunction|BufMapFunction
local function variant(mode, func, with_buf)
	if not (is_fun(func) and is_str(mode) and vim.tbl_contains(MODES, mode)) then
		error('(user.maps:variant): Argument of incorrect type.')
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
			b = is_int(b) and b or vim.api.nvim_get_current_buf()

			for _, v in next, DEFAULTS do
				opts[v] = is_bool(opts[v]) and opts[v] or true
			end

			func(b, mode, lhs, rhs, opts)
		end
	end

	return res
end

---@type fun(key: 'api'|'key'|'buf'): UserMaps.Keymap|UserMaps.Api|UserMaps.Buf
local mode_funcs = function(key)
	---@type table<'api'|'key'|'buf', { integer: fun(), integer: boolean }>
	local VALID = { api = { map, false }, key = { kmap, false }, buf = { bufmap, true } }

	if not field(key, VALID) then
		error('(user.maps:mode_funcs): Invalid variant ID `' .. field .. "`\nMust be `'api'|'key'|'buf'`")
	end

	---@type UserMaps.Keymap|UserMaps.Api|UserMaps.Buf
	local res = {}

	for _, mode in next, MODES do
		res[mode] = variant(mode, VALID[key][1], VALID[key][2])
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

function M.kmap.desc(msg, silent, bufnr, noremap, nowait, expr)
	---@type UserMaps.Keymap.Opts
	local res = {
		desc = (is_str(msg) and not empty(msg)) and msg or 'Unnamed Key',
		silent = is_bool(silent) and silent or true,
		noremap = is_bool(noremap) and noremap or true,
		nowait = is_bool(nowait) and nowait or true,
		expr = is_bool(expr) and expr or false,
	}

	if is_int(bufnr) then
		res.buffer = bufnr
	end

	return res
end

for _, key in next, { M.map, M.buf_map } do
	function key.desc(msg, silent, noremap, nowait, expr)
		return {
			desc = (is_str(msg) and not empty(msg)) and msg or 'Unnamed Key',
			silent = is_bool(silent) and silent or true,
			noremap = is_bool(noremap) and noremap or true,
			nowait = is_bool(nowait) and nowait or true,
			expr = is_bool(expr) and expr or false,
		}
	end
end

function M.nop(T, opts, mode)
	if not (is_str(T) or is_tbl(T)) then
		error('(user.maps.nop): Argument is neither a string nor a table.')
	end

	mode = (is_str(mode) and vim.tbl_contains(M.modes, mode)) and mode or 'n'
	if mode == 'i' then
		return
	end

	opts = is_tbl(opts) and opts or {}

	for _, v in next, { 'nowait', 'noremap' } do
		opts[v] = is_bool(opts[v]) and opts[v] or false
	end

	opts.silent = is_bool(opts.silent) and opts.silent or true

	if is_int(opts.buffer) then
		opts = strip_options(vim.deepcopy(opts), 'buffer')
	end

	if is_str(T) then
		M.kmap[mode](T, '<Nop>', opts)
	else
		for _, v in next, T do
			M.kmap[mode](v, '<Nop>', opts)
		end
	end
end

--- `which_key` API entrypoints
M.wk = {
	available = function()
		return Check.exists.module('which-key')
	end,
	convert = function(rhs, opts)
		if not ((is_str(rhs) and not empty(rhs)) or is_fun(rhs)) then
			error('(user.maps.wk.convert): Incorrect argument types!')
		end

		local DEFAULT_OPTS = { 'noremap', 'nowait', 'silent' }

		opts = is_tbl(opts) and opts or {}

		for _, o in next, DEFAULT_OPTS do
			opts[o] = is_bool(opts[o]) and opts[o] or true
		end

		---@type RegKey
		local res = { rhs }

		if is_str(opts.desc) and not empty(opts.desc) then
			table.insert(res, opts.desc)
		end

		for _, o in next, DEFAULT_OPTS do
			res[o] = opts[o]
		end

		return res
	end,
}

function M.wk.convert_dict(T)
	if not is_tbl(T) or empty(T) then
		error('(user.maps.wk.convert_dict): Argument empty or not a table')
	end

	---@type RegKeys
	local res = {}

	for lhs, v in next, T do
		v[2] = is_tbl(v[2]) and v[2] or {}

		res[lhs] = M.wk.convert(v[1], v[2])
	end

	return res
end

function M.wk.register(T, opts)
	if not M.wk.available() then
		return false
	end

	if not is_tbl(T) or empty(T) then
		error('(user.maps.wk.register): Parameter is not a table')
	end

	local WK = require('which-key')
	local DEFAULT_OPTS = { 'noremap', 'nowait', 'silent' }

	opts = is_tbl(opts) and opts or {}

	opts.mode = is_str(opts.mode) and vim.tbl_contains(MODES, opts.mode) and opts.mode or 'n'

	for _, o in next, DEFAULT_OPTS do
		if not is_bool(opts[o]) then
			opts[o] = (o ~= 'nowait') and true or false
		end
	end

	---@type RegKeys|RegKeysNamed
	local filtered = {}

	for lhs, v in next, T do
		local tbl = vim.deepcopy(v)

		for _, o in next, DEFAULT_OPTS do
			tbl[o] = is_bool(tbl[o]) and tbl[o] or opts[o]
		end

		filtered[lhs] = tbl
	end

	WK.register(filtered, opts)
end

return M
