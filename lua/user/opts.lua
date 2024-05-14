---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.opts')

local Check = require('user.check')

local exists = Check.exists.vim_exists
local has = Check.exists.vim_has
local executable = Check.exists.executable
local is_nil = Check.value.is_nil

---@type boolean
vim.g.is_windows = has('win32')
---@type boolean
_G.is_windows = vim.g.is_windows

---@type OptsTbl
local opt_tbl = {
	autoindent = true,
	autoread = true,
	backspace = { 'indent', 'eol', 'start' },
	backup = false,
	belloff = { 'all' },
	background = 'dark',
	copyindent = true,
	cmdwinheight = 4,
	-- colorcolumn = { '+1' },
	completeopt = { 'menu', 'menuone', 'noselect', 'noinsert', 'preview' },
	confirm = true,
	encoding = 'utf-8',
	equalalways = true,
	errorbells = false,
	expandtab = false,
	fileencoding = 'utf-8',
	fileignorecase = is_windows,
	formatoptions = 'oqwnbljp',
	hidden = true,
	helplang = { 'en' },
	hlsearch = true,
	ignorecase = false,
	incsearch = true,
	laststatus = 2,
	makeprg = is_windows and 'mingw32-make' or 'make',
	matchpairs = {
		'(:)',
		'[:]',
		'{:}',
		'<:>',
	},
	matchtime = 30,
	menuitems = 40,
	mouse = '',
	number = true,
	preserveindent = true,
	relativenumber = false,
	ruler = true,
	sessionoptions = {
		"buffers",
		"tabpages",
		"globals",
	},
	shell = (is_windows and 'cmd.exe' or 'bash'),
	scrolloff = 3,
	showcmd = true,
	showmatch = true,
	showmode = false,
	smartindent = true,
	signcolumn = 'yes',
	smartcase = true,
	spell = false,
	splitbelow = true,
	splitright = true,
	smarttab = true,
	showtabline = 2,
	softtabstop = 4,
	shiftwidth = 0,
	termguicolors = true,
	title = true,
	tabstop = 4,
	updatecount = 100,
	updatetime = 1000,
	visualbell = false,
	wildmenu = true,
	wrap = false,
}

if is_windows then
	opt_tbl.shellslash = true
	if executable('mingw32-make') then
		opt_tbl.makeprg = 'mingw32-make'
	elseif executable('make') then
		opt_tbl.makeprg = 'make'
	end
end

---@type fun(opts: OptsTbl)
local function optset(opts)
	for k, v in next, opts do
		if not is_nil(vim.opt[k]) then
			vim.opt[k] = v
		elseif not is_nil(vim.o[k]) then
			vim.o[k] = v
		else
			error('Unable to set option `' .. k .. '`')
		end
	end
end

optset(opt_tbl)
