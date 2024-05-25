---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require("user.types.user.opts")

local Check = require("user.check")

local exists = Check.exists.vim_exists
local is_nil = Check.value.is_nil
local executable = Check.exists.executable
local vim_has = Check.exists.vim_has
local vim_exists = Check.exists.vim_exists

_G.is_windows = vim_has("win32")

---@type OptsTbl
local opt_tbl = {
	autoindent = true,
	autoread = true,
	backspace = { "indent", "eol", "start" },
	backup = false,
	belloff = { "all" },
	background = "dark",
	copyindent = true,
	cmdwinheight = 3,
	colorcolumn = { "+1" },
	completeopt = { "menu", "menuone", "noselect", "noinsert", "preview" },
	confirm = true,
	encoding = "utf-8",
	equalalways = true,
	errorbells = false,
	expandtab = false,
	fileencoding = "utf-8",
	fileignorecase = is_windows,
	formatoptions = "bjlopqnw",
	hidden = true,
	helplang = { "en" },
	hlsearch = true,
	ignorecase = false,
	incsearch = true,
	laststatus = 2,
	makeprg = "make",
	matchpairs = {
		"(:)",
		"[:]",
		"{:}",
		"<:>",
	},
	matchtime = 30,
	menuitems = 40,
	mouse = "", -- Get that mouse out of my sight!
	number = true,
	preserveindent = true,
	relativenumber = false,
	ruler = true,
	sessionoptions = {
		"buffers",
		"tabpages",
		"globals",
	},
	shell = "bash",
	scrolloff = 3,
	showcmd = true,
	showmatch = true,
	showmode = false,
	smartindent = true,
	signcolumn = "yes",
	smartcase = true,
	spell = false,
	splitbelow = true,
	splitright = true,
	smarttab = true,
	showtabline = 2,
	softtabstop = 4,
	shiftwidth = 0,
	termguicolors = vim_exists("+termguicolors"),
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
	opt_tbl.shell = executable("bash.exe") and "bash.exe" or "cmd.exe"

	opt_tbl.makeprg = executable("mingw32-make.exe") and "mingw32-make.exe" or opt_tbl.makeprg
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
			vim.notify("(user.opts:optset): Unable to set option `" .. k .. "`")
		end
	end
end

optset(opt_tbl)
