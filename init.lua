---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local set = vim.o
local opt = vim.opt
local fn = vim.fn
local api = vim.api
local let = vim.g
local lsp = vim.lsp
local bo = vim.bo

local map = api.nvim_set_keymap
local hi = api.nvim_set_hl
local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

require('user.types')
local User = require('user')
local exists = User.exists
local options = User.opts

local Pkg = {}

if exists('lazy_cfg') then
	Pkg = require('lazy_cfg')
end

---@type MapOpts
local s_noremap = { noremap = true, silent = true }
---@type MapOpts
local ns_noremap = { noremap = true, silent = false }

map('t', '<Esc>', '<C-\\><C-n>', s_noremap)

map('n', '<Leader>fn', ':edit ', ns_noremap)
map('n', '<Leader>fs', ':w<CR>', s_noremap)
map('n', '<Leader>fS', ':w ', ns_noremap)

map('n', '<Leader>fvs', ':luafile $MYVIMRC<CR>', s_noremap)
map('n', '<Leader>fve', ':tabnew $MYVIMRC<CR>', ns_noremap)

map('n', '<Leader>wss', ':split<CR>', s_noremap)
map('n', '<Leader>wsv', ':vsplit<CR>', s_noremap)
map('n', '<Leader>wsS', ':split ', ns_noremap)
map('n', '<Leader>wsV', ':vsplit ', ns_noremap)

map('n', '<Leader>qq', ':qa<CR>', s_noremap)
map('n', '<Leader>qQ', ':qa!<CR>', s_noremap)

map('n', '<Leader>tn', ':tabN<CR>', ns_noremap)
map('n', '<Leader>tp', ':tabp<CR>', ns_noremap)
map('n', '<Leader>td', ':tabc<CR>', s_noremap)
map('n', '<Leader>tD', ':tabc!<CR>', s_noremap)
map('n', '<Leader>tf', ':tabfirst<CR>', s_noremap)
map('n', '<Leader>tl', ':tablast<CR>', s_noremap)
map('n', '<Leader>ta', ':tabnew ', ns_noremap)
map('n', '<Leader>tA', ':tabnew<CR>', s_noremap)

map('n', '<Leader>bn', ':bN<CR>', ns_noremap)
map('n', '<Leader>bp', ':bp<CR>', ns_noremap)
map('n', '<Leader>bd', ':bdel<CR>', s_noremap)
map('n', '<Leader>bD', ':bdel!<CR>', s_noremap)
map('n', '<Leader>bf', ':bfirst<CR>', s_noremap)
map('n', '<Leader>bl', ':blast<CR>', s_noremap)

map('v', '<Leader>is', ':sort<CR>', ns_noremap)

set.fileformat = 'unix'
set.encoding = 'utf-8'
set.fileencoding = 'utf-8'

set.formatoptions = 'orq'

set.completeopt = 'menu,menuone,noinsert,noselect,preview'
opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }

set.backspace = 'indent,eol,start'
set.mouse = ''
set.ruler = true
set.laststatus = 2
set.hidden = true
set.showtabline = 2
set.wrap = true
set.wildmenu = true
set.showcmd = true
set.showmode = false
set.autoread = true
set.spell = false
-- set.secure = true
set.confirm = true

set.incsearch = true
set.hlsearch = true
set.showmatch = true

set.smartcase = true
set.ignorecase = false

set.number = true
set.relativenumber = false
set.signcolumn = 'yes'

set.background = 'dark'
set.termguicolors = true

set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = false
set.autoindent = true
set.smartindent = true
set.smarttab = true
set.copyindent = true
set.preserveindent = true

set.splitbelow = true
set.splitright = true

set.belloff = 'all'
set.visualbell = false

local User = require('user')
local exists = User.exists

let.loaded_netrw = 1
let.loaded_netrwPlugin = 1

local Pkg = (exists('lazy_cfg') and require('lazy_cfg') or nil)

vim.cmd[[
filetype plugin indent on
syntax on
]]

User.assoc()
