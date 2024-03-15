---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local set = vim.o
local fn = vim.fn
local api = vim.api
local let = vim.g
local lsp = vim.lsp

local map = api.nvim_set_keymap

-- TODO: Make the option table.
local opt_tbl = {}

map('n', '<Space>', '<Nop>', { noremap = true, silent = true })
let.mapleader = ' '
let.maplocalleader = ' '
let.loaded_netrw = 1
let.loaded_netrwPlugin = 1

vim.cmd[[
filetype plugin indent on
syntax on
]]

map('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

map('n', '<Leader>fn', ':edit ', { noremap = true, silent = false })
map('n', '<Leader>fs', ':w<CR>', { noremap = true, silent = true })
map('n', '<Leader>fS', ':w ', { noremap = true, silent = false })

map('n', '<Leader>fvs', ':luafile $MYVIMRC<CR>', { noremap = true, silent = true })
map('n', '<Leader>fve', ':tabnew $MYVIMRC<CR>', { noremap = true, silent = false })

map('n', '<Leader>wss', ':split<CR>', { noremap = true, silent = true })
map('n', '<Leader>wsv', ':vsplit<CR>', { noremap = true, silent = true })
map('n', '<Leader>wsS', ':split ', { noremap = true, silent = false })
map('n', '<Leader>wsV', ':vsplit ', { noremap = true, silent = false })

map('n', '<Leader>qq', ':qa<CR>', { noremap = true, silent = true })
map('n', '<Leader>qQ', ':qa!<CR>', { noremap = true, silent = true })

map('n', '<Leader>tn', ':tabN<CR>', { noremap = true, silent = false })
map('n', '<Leader>tp', ':tabp<CR>', { noremap = true, silent = false })
map('n', '<Leader>td', ':tabc<CR>', { noremap = true, silent = true })
map('n', '<Leader>tD', ':tabc!<CR>', { noremap = true, silent = true })
map('n', '<Leader>tf', ':tabfirst<CR>', { noremap = true, silent = true })
map('n', '<Leader>tl', ':tablast<CR>', { noremap = true, silent = true })
map('n', '<Leader>ta', ':tabnew ', { noremap = true, silent = false })
map('n', '<Leader>tA', ':tabnew<CR>', { noremap = true, silent = true })

map('n', '<Leader>bn', ':bN<CR>', { noremap = true, silent = false })
map('n', '<Leader>bp', ':bp<CR>', { noremap = true, silent = false })
map('n', '<Leader>bd', ':bdel<CR>', { noremap = true, silent = true })
map('n', '<Leader>bD', ':bdel!<CR>', { noremap = true, silent = true })
map('n', '<Leader>bf', ':bfirst<CR>', { noremap = true, silent = true })
map('n', '<Leader>bl', ':blast<CR>', { noremap = true, silent = true })

map('v', '<Leader>is', ':sort<CR>', { noremap = true, silent = false })

set.fileformat = 'unix'
set.encoding = 'utf-8'
set.fileencoding = 'utf-8'

set.formatoptions = 'orq'

-- hi.all()
set.completeopt = 'menu,menuone,noinsert,noselect,preview'

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

User.assoc()

local Pkg = (exists('lazy_cfg') and require('lazy_cfg') or nil)
