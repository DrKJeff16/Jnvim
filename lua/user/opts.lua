---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.opts')
require('user.types.user.check')

---@type UserCheck
local Check = require('user.check')

local exists = Check.exists.vim_exists
local is_nil = Check.value.is_nil
local executable = Check.exists.executable
local has = Check.exists.vim_has or function(expr)
	return vim.fn.has(expr) == 1
end

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
	cmdwinheight = 3,
	colorcolumn = { '+1' },
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
	makeprg = 'make',
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
	shell = is_windows and 'cmd.exe' or 'bash',
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

	opt_tbl.makeprg = executable('mingw32-make') and 'mingw32-make' or 'make'
end

---@type fun(opts: OptsTbl)
local function optset(opts)
	for k, v in next, opts do
		if not is_nil(vim.opt[k]) then
			vim.opt[k] = v
		elseif not is_nil(vim.o[k]) then
			vim.o[k] = v
		else
			error('(user.opts): Unable to set option `' .. k .. '`')
		end
	end
end

optset(opt_tbl)
