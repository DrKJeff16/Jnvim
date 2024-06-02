---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.opts')

local Check = require('user.check')
local Util = require('user.util')

local exists = Check.exists.vim_exists
local is_nil = Check.value.is_nil
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console
local notify = Util.notify.notify

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
	fileignorecase = false,
	formatoptions = 'bjlopqnw',
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
	mouse = '', -- Get that mouse out of my sight!
	number = true,
	preserveindent = true,
	relativenumber = false,
	ruler = true,
	sessionoptions = {
		'buffers',
		'tabpages',
		'globals',
	},
	shell = executable('bash') and 'bash' or 'sh',
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
	termguicolors = vim_exists('+termguicolors') and not in_console(),
	title = true,
	tabstop = 4,
	updatecount = 100,
	updatetime = 1000,
	visualbell = false,
	wildmenu = true,
	wrap = false,
}

if is_windows then
	opt_tbl.fileignorecase = true
	opt_tbl.makeprg = executable('mingw32-make.exe') and 'mingw32-make.exe' or opt_tbl.makeprg

	opt_tbl.shell = 'cmd.exe'
	if executable('bash.exe') then
		opt_tbl.shell = 'bash.exe'
		opt_tbl.shellcmdflag = '-c'
	elseif executable('sh.exe') then
		opt_tbl.shell = 'sh.exe'
		opt_tbl.shellcmdflag = '-c'
	else
		opt_tbl.shell = 'cmd.exe'
	end

	opt_tbl.shellslash = true
end

--- Option setter for the aforementioned options dictionary.
--- ---
--- ## Parameters
--- * `opts`: A dictionary with keys as `vim.opt` or `vim.o` fields, and values for each option
--- respectively.
--- ---
---@type fun(opts: OptsTbl)
local function optset(opts)
	for k, v in next, opts do
		if not is_nil(vim.opt[k]) then
			vim.opt[k] = v
		elseif not is_nil(vim.o[k]) then
			vim.o[k] = v
		else
			notify('(user.opts:optset): Unable to set option `' .. k .. '`', 'error', { title = 'user.opts' })
		end
	end
end

optset(opt_tbl)
