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
		['completeopt'] = { 'menu', 'menuone', 'noselect', 'noinsert', 'preview' },
		['termguicolors'] = true,
	},
	set = {
		['hid'] = true,
		['hlg'] = 'en',  -- `helplang`
		['spell'] = false,
		['mouse'] = '',
		['bs'] = 'indent,eol,start',  -- `backspace`
		['formatoptions'] = 'orq',
		['enc'] = 'utf-8',
		['fenc'] = 'utf-8',
		['ff'] = 'unix',
		['wrap'] = true,

		['completeopt'] = 'menu,menuone,noselect,noinsert,preview',

		['errorbells'] = false,
		['visualbell'] = false,
		['belloff'] = 'all',

		['nu'] = true,
		['relativenumber'] = false,
		['signcolumn'] = 'yes',

		['ts'] = 4,
		['sts'] = 4,
		['sw'] = 4,
		['ai'] = true,
		['si'] = true,
		['sta'] = true,
		['ci'] = true,
		['pi'] = true,
		['et'] = false,

		['bg'] = 'dark',
		['tgc'] = true,  -- `termguicolors`

		['splitbelow'] = true,
		['splitright'] = true,

		['ru'] = true,
		['stal'] = 2,
		['ls'] = 2,
		['title'] = true,
		['showcmd'] = true,
		['wildmenu'] = true,
		['showmode'] = false,

		['ar'] = true,
		['confirm'] = true,

		['smartcase'] = true,
		['ignorecase'] = false,

		['hlsearch'] = true,
		['incsearch'] = true,
		['showmatch'] = true,
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
