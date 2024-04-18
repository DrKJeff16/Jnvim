---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.opts')
local Check = require('user.check')

local opt = vim.opt
local let = vim.g
local fn = vim.fn

local has = fn.has
local exists = fn.exists
local executable = Check.exists.executable

---@type 0|1
let.is_windows = has('win32')
---@type boolean
_G.is_windows = let.is_windows == 1

---@type OptsTbl
local opt_tbl = {
	ai = true,  -- `autoindent`
	ar = true,  -- `autoread`
	backspace = { 'indent', 'eol', 'start' },
	backup = false,
	belloff = { 'all' },
	bg = 'dark',  -- `background`
	ci = true,  -- `copyindent`
	colorcolumn = { '+1' },
	completeopt = { 'menu', 'menuone', 'noselect', 'noinsert', 'preview' },
	confirm = true,
	enc = 'utf-8',  -- `encoding`
	equalalways = true,
	errorbells = false,
	et = false,  -- `expandtab`
	fenc = 'utf-8',  -- `fileencoding`
	ff = 'unix',  -- `fileformat`
	fileignorecase = _G.is_windows,
	formatoptions = 'oqwnbljp',
	hid = true,  -- `hidden`
	hlg = { 'en' },  -- `helplang`
	hlsearch = true,
	ignorecase = false,
	incsearch = true,
	ls = 2,  -- `laststatus`
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
	rnu = false,
	ru = true,  -- `ruler`
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
	tgc = exists('+termguicolors') == 1,  -- `termguicolors`
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

---@param opts UserO|UserOpt
local optset = function(opts)
	for k, v in next, opts do
		vim.opt[k] = v
	end
end

optset(opt_tbl)
