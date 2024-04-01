---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

if not vim then
	return
end

local pfx = 'user.'

require('user.types')

local set = vim.o
local opt = vim.opt
local bo = vim.bo

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
		tgc = true,  -- `termguicolors`

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

		hlsearch = true,
		incsearch = true,
		showmatch = true,
	},
}

---@param opts OptPairTbl
---@param vim_tbl? table
local optset = function(opts, vim_tbl)
	vim_tbl = vim_tbl or vim.o
	for k, v in next, opts do
		vim_tbl[k] = v
	end
end

optset(opt_tbl.set, set)
optset(opt_tbl.opt, opt)
