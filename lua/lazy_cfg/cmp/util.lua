---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.cmp

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

if not exists('cmp') then
	error('No `cmp` module!')
	return
end

local Luasnip = require('lazy_cfg.cmp.luasnip')
local cmp = require('cmp')
local Types = require('cmp.types')
local CmpTypes = require('cmp.types.cmp')

local api = vim.api

local tbl_contains = vim.tbl_contains
local get_mode = api.nvim_get_mode
local buf_lines = api.nvim_buf_get_lines
local win_cursor = api.nvim_win_get_cursor

local M = {}

---@return boolean
function M.has_words_before()
	unpack = unpack or table.unpack

	-- local buf_lines = api.nvim_buf_get_lines
	-- local win_cursor = api.nvim_win_get_cursor

	local line, col = unpack(win_cursor(0))
	return col ~= 0 and buf_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

---@param fallback fun()
function M.n_select(fallback)
	local jumpable = Luasnip.expand_or_locally_jumpable
	---@type cmp.SelectOption
	local opts = { behavior = cmp.SelectBehavior.Insert }

	if cmp.visible() then
		cmp.select_next_item(opts)
	elseif jumpable() then
		Luasnip.expand_or_jump()
	elseif M.has_words_before() then
		cmp.complete()
		if cmp.visible() then
			cmp.select_next_item(opts)
		end
	else
		fallback()
	end
end

---@param fallback fun()
function M.n_shift_select(fallback)
	local jumpable = Luasnip.jumpable(-1)
	---@type cmp.SelectOption
	local opts = { behavior = cmp.SelectBehavior.Replace }

	if cmp.visible() then
		cmp.select_prev_item(opts)
	elseif jumpable() then
		Luasnip.jump(-1)
	elseif M.has_words_before() then
		cmp.complete()
		if cmp.visible() then
			cmp.select_prev_item(opts)
		end
	else
		fallback()
	end
end

---@param opts? cmp.ConfirmOption
---@return fun(fallback: fun())
function M.confirm(opts)
	if not is_tbl(opts) then
		opts = {}
	end

	if is_nil(opts.behavior) then
		opts.behavior = cmp.ConfirmBehavior.Replace
	end
	if not is_bool(opts.select) then
		opts.select = false
	end

	return function(fallback)
		if cmp.visible() and cmp.get_selected_entry() then
			cmp.confirm(opts)
		else
			fallback()
		end
	end
end

---@type TabMap
M.tab_map = {
	i = M.n_select,
	s = M.n_select,
	---@param fallback fun()
	c = function(fallback)
		local opts = { behavior = cmp.SelectBehavior.Insert }

		if cmp.visible() then
			cmp.select_next_item(opts)
		elseif M.has_words_before() then
			cmp.complete()
		else
			fallback()
		end
	end,
}

M.s_tab_map = {
	i = M.n_shift_select,
	s = M.n_shift_select,
	---@param fallback fun()
	c = function(fallback)
		local opts = { behavior = cmp.SelectBehavior.Select }

		if cmp.visible() then
			cmp.select_prev_item(opts)
		elseif M.has_words_before() then
			cmp.complete()
		else
			fallback()
		end
	end,
}

---@type CrMap
M.cr_map = {
	i = M.confirm(),
	s = M.confirm(),
	c = M.confirm({ select = true }),
}

---@param fallback fun()
function M.bs_map(fallback)
	if cmp.visible() then
		cmp.close()
	end
	fallback()
end

return M
