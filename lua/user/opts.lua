---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.opts')

local set = vim.o
local opt = vim.opt
local bo = vim.bo
local let = vim.g
local fn = vim.fn
local api = vim.api

local has = fn.has
local exists = fn.exists

---@type 0|1
let.is_windows = has('win32')

_G.is_windows = let.is_windows == 1

---@type OptsTbl
local opt_tbl = {
	opt = {
		completeopt = { 'menu', 'menuone', 'noselect', 'noinsert', 'preview' },
		termguicolors = true,
	},
	set = {
		hid = true,  -- `hidden`
		hlg = 'en',  -- `helplang`
		spell = false,
		mouse = '',
		bs = 'indent,eol,start',  -- `backspace`
		formatoptions = 'orq',
		enc = 'utf-8',  -- `encoding`
		fenc = 'utf-8',  -- `fileencoding`
		ff = 'unix',  -- `fileformat`
		wrap = true,

		completeopt = 'menu,menuone,noselect,noinsert,preview',

		errorbells = false,
		visualbell = false,
		belloff = 'all',

		nu = true,  -- `number`
		relativenumber = false,
		signcolumn = 'yes',

		ts = 4,  -- `tabstop`
		sts = 4,  -- `softtabstop`
		sw = 4,  -- `shiftwidth`
		ai = true,  -- `autoindent`
		si = true,  -- `smartindent`
		sta = true,  -- `smarttab`
		ci = true,  -- `copyindent`
		pi = true,  -- `preserveindent`
		et = false,  -- `expandtab`

		bg = 'dark',  -- `background`
		tgc = exists('+termguicolors') == 1,  -- `termguicolors`

		splitbelow = true,
		splitright = true,

		ru = true,  -- `ruler`
		stal = 2,  -- `showtabline`
		ls = 2,  -- `laststatus`
		title = true,
		showcmd = true,
		wildmenu = true,
		showmode = false,

		ar = true,  -- `autoread`
		confirm = true,

		smartcase = true,
		ignorecase = false,

		fileignorecase = is_windows,

		hlsearch = true,
		incsearch = true,
		showmatch = true,

		-- shellslash = is_windows,
	},
}

if is_windows then
	opt_tbl.opt.shellslash = true
end

---@param opts UserO|UserOpt
---@param target?
---|'o'
---|'set'
---|'opt'
local optset = function(opts, target)
	if not target or not vim.tbl_contains({ 'o', 'set', 'opt' }, target) then
		target = 'o'
	end

	for k, v in next, opts do
		local vim_tbl = {}

		if vim.tbl_contains({'o', 'set'}, target) then
			vim_tbl = vim.o
		elseif vim.tbl_contains({'opt'}, target) then
			vim_tbl = vim.opt
		end

		vim_tbl[k] = v
	end
end

optset(opt_tbl.set, 'set')
optset(opt_tbl.opt, 'opt')
