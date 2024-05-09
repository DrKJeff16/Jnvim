---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.opts')
local Check = require('user.check')

local exists = Check.exists.vim_exists
local executable = Check.exists.executable
local is_nil = Check.value.is_nil

local has = vim.fn.has

---@type 0|1
vim.g.is_windows = has('win32')
---@type boolean
_G.is_windows = vim.g.is_windows == 1

---@type OptsTbl
local opt_tbl = {
	ai = true,  -- `autoindent`
	ar = true,  -- `autoread`
	backspace = { 'indent', 'eol', 'start' },
	backup = false,
	belloff = { 'all' },
	bg = 'dark',  -- `background`
	ci = true,  -- `copyindent`
	cmdwinheight = 4,
	colorcolumn = { '+1' },
	completeopt = { 'menu', 'menuone', 'noselect', 'noinsert', 'preview' },
	confirm = true,
	enc = 'utf-8',  -- `encoding`
	equalalways = true,
	errorbells = false,
	et = false,  -- `expandtab`
	fenc = 'utf-8',  -- `fileencoding`
	ff = 'unix',  -- `fileformat`
	fileignorecase = is_windows,
	formatoptions = 'oqwnbljp',
	hid = true,  -- `hidden`
	hlg = { 'en' },  -- `helplang`
	hlsearch = true,
	ignorecase = false,
	incsearch = true,
	ls = 2,  -- `laststatus`
	makeprg = 'make',
	mps = {
		'(:)',
		'[:]',
		'{:}',
		'<:>',
	},  -- `matchpairs`
	mat = 30,  -- `matchtime`
	mis = 40,  -- `menuitems`
	mouse = '',
	nu = true,  -- `number`
	pi = true,  -- `preserveindent`
	rnu = false,  -- `relativenumber`
	ru = true,  -- `ruler`
	sessionoptions = {
		"buffers",
		"tabpages",
		"globals",
	},
	sh = (is_windows and 'cmd.exe' or 'bash'),  -- `shell`
	so = 1,  -- `scrolloff`
	showcmd = true,
	showmatch = true,
	showmode = false,
	si = true,  -- `smartindent`
	signcolumn = 'yes',
	smartcase = true,
	spell = false,
	splitbelow = true,
	splitright = true,
	sta = true,  -- `smarttab`
	stal = 2,  -- `showtabline`
	sts = 4,  -- `softtabstop`
	sw = 0,  -- `shiftwidth`
	tgc = exists('+termguicolors'),  -- `termguicolors`
	title = true,
	ts = 4,  -- `tabstop`
	uc = 100,  -- `updatecount`
	ut = 1000,  -- `updatetime`
	visualbell = false,
	wildmenu = true,
	wrap = true,
}

if is_windows then
	opt_tbl.shellslash = true
	if executable('mingw32-make') then
		opt_tbl.makeprg = 'mingw32-make'
	elseif executable('make') then
		opt_tbl.makeprg = 'make'
	else
		opt_tbl.makeprg = ''
	end
end

---@param opts UserOpt
local function optset(opts)
	for k, v in next, opts do
		if not is_nil(vim.opt[k]) then
			vim.opt[k] = v
		elseif not is_nil(vim.o[k]) then
			vim.o[k] = v
		end
	end
end

optset(opt_tbl)

vim.o.relativenumber = false
