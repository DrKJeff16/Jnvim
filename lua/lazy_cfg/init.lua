---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.lazy')
require('user.types.colorschemes')

local fn = vim.fn
local opt = vim.opt
local let = vim.g
local set = vim.o
local api = vim.api

local rtp = opt.rtp
local fs_stat = vim.loop.fs_stat
local stdpath = fn.stdpath
local system = fn.system
local has = fn.has
local vim_exists = fn.exists
local executable = fn.executable

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

-- Set installation dir for `Lazy`.
local lazypath = stdpath('data') .. '/lazy/lazy.nvim'

local User = require('user')
local exists = User.exists

-- Install `Lazy` automatically.
if not exists('lazy') or not fs_stat(lazypath) then
	system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end

-- Add `Lazy` to `stdpath`
rtp:prepend(lazypath)

local Lazy = require('lazy')

---@type LazyConfig
local opts = require('lazy_cfg.lazy.opts')

Lazy.setup({
	{ 'folke/lazy.nvim', priority = 1000 },

	{ 'vim-scripts/L9', lazy = false, priority = 1000 },

	{
		'nvim-lua/plenary.nvim',
		lazy = true,
		priority = 1000,
		name = 'Plenary',
		cmd = {
			'PlenaryBustedFile',
			'PlenaryBustedDirectory',
		},
	},
	{
		'nvim-lua/popup.nvim',
		lazy = true,
		priority = 1000,
		name = 'Popup',
		dependencies = { 'Plenary' },
	},

	{ 'nvim-tree/nvim-web-devicons', lazy = true, priority = 1000, name = 'web-devicons' },

	{
		'numToStr/Comment.nvim',
		name = 'Comment',
		dependencies = {
			'treesitter',
			'ts-commentstring',
		},
		init = function()
			let.Comment_installed = 1
		end,
		config = function()
			return require('lazy_cfg.Comment')
		end,
		enabled = function()
			return not let.commentary_installed and let.commentary_installed ~= 1
		end
	},
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		lazy = true,
		name = 'ts-commentstring',
	},

	-- Tpope is god.
	{
		'tpope/vim-commentary',
		lazy = false,
		enabled = function()
			return not let.Comment_installed and let.Comment_installed ~= 1
		end
	},
	{ 'tpope/vim-endwise', lazy = false },
	{ 'tpope/vim-fugitive', lazy = false, name = 'Fugitive', enabled = executable('git') == 1 },
	{ 'tpope/vim-speeddating', enabled = false },

	-- Treesitter.
	{
		'nvim-treesitter/nvim-treesitter',
		priority = 1000,
		name = 'treesitter',
		build = ':verbose TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-orgmode/orgmode',
			'JoosepAlviste/nvim-ts-context-commentstring',
			-- 'HiPhish/nvim-ts-rainbow2',
		},
		config = function()
			return require('lazy_cfg.treesitter')
		end,
	},
	{ 'nvim-orgmode/orgmode', lazy = true, ft = 'org' },

	-- LSP
	{
		'neovim/nvim-lspconfig',
		lazy = false,
		priority = 1000,
		name = 'lspconfig',
		dependencies = {
			'neodev',
			'NeoConf',
			'b0o/SchemaStore.nvim',
			'p00f/clangd_extensions.nvim',
		},
		config = function()
			return require('lazy_cfg.lspconfig')
		end,
	},
	-- Essenyial for Nvim Lua files.
	{
		'folke/neodev.nvim',
		lazy = true,
		priority = 1000,
		name = 'neodev',
		dependencies = { 'NeoConf' },
		enabled = executable('lua-language-server') == 1,
	},
	{
		'folke/neoconf.nvim',
		lazy = true,
		priority = 1000,
		name = 'NeoConf',
	},
	{ 'p00f/clangd_extensions.nvim', lazy = true, enabled = executable('clangd') == 1 },

	-- Colorschemes
	{
		'pineapplegiant/spaceduck',
		lazy = false,
		priority = 1000,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			let.installed_spaceduck = 1
		end,
	},
	{ 'catppuccin/nvim', lazy = true, priority = 1000, name = 'catppuccin' },
	{ 'folke/tokyonight.nvim', lazy = true, priority = 1000, name = 'tokyonight' },
	{ 'vigoux/oak', lazy = true, priority = 1000 },
	{
		'bkegley/gloombuddy',
		lazy = true,
		priority = 1000,
		dependencies = { 'colorbuddy' },
	},
	{
		'tjdevries/colorbuddy.vim',
		lazy = true,
		priority = 1000,
		name = 'colorbuddy',
	},
	{
		'EdenEast/nightfox.nvim',
		lazy = true,
		priority = 1000,
		name = 'nightfox',
	},

	{
		'folke/todo-comments.nvim',
		priority = 1000,
		name = 'todo-comments',
		dependencies = {
			'treesitter',
			'Plenary',
		},
		config = function()
			return require('lazy_cfg.todo_comments')
		end,
	},

	-- Completion Engine
	{
		'hrsh7th/nvim-cmp',
		name = 'cmp',
		dependencies = {
			'treesitter',
			'lspconfig',
			'onsails/lspkind.nvim',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-nvim-lsp-document-symbol',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'petertriho/cmp-git',
			'davidsierradz/cmp-conventionalcommits',
			'FelipeLema/cmp-async-path',
			'hrsh7th/cmp-cmdline',
			'saadparwaiz1/cmp_luasnip',
			'LuaSnip',
		},
		init = function()
			set.completeopt = 'menu,menuone,noinsert,noselect,preview'
			opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
		end,
		config = function()
			return require('lazy_cfg.cmp')
		end,
	},
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		dependencies = { 'rafamadriz/friendly-snippets' },
		build = 'make -j"$(nproc)" install_jsregexp',
	},

	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		priority = 1000,
		name = 'Telescope',
		cmd = 'Telescope',
		dependencies = {
			'Telescope-fzf',
			'treesitter',
			'lspconfig',
			'Plenary',
			'Project',
		},
		config = function()
			return require('lazy_cfg.telescope')
		end,
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		name = 'Telescope-fzf',
		build = 'make -j"$(nproc)"',
		enabled = executable('fzf') == 1,
	},
	-- Project Manager
	{
		'ahmedkhalf/project.nvim',
		lazy = true,
		priority = 1000,
		name = 'Project',
	},

	-- Statusline
	{
		'nvim-lualine/lualine.nvim',
		priority = 1000,
		name = 'LuaLine',
		dependencies = { 'web-devicons' },
		config = function()
			return require('lazy_cfg.lualine')
		end,
	},
	{
		'akinsho/bufferline.nvim',
		lazy = true,
		priority = 1000,
		name = 'BufferLine',
		dependencies = { 'web-devicons' },
	},

	-- Auto-pairing (**BROKEN**)
	{
		'windwp/nvim-autopairs',
		lazy = true,
		name = 'AutoPairs',
		config = function()
			return require('lazy_cfg.autopairs')
		end,
		enabled = false,
	},

	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		name = 'ibl',
		dependencies = { 'rainbow-delimiters' },
		config = function()
			return require('lazy_cfg.blank_line')
		end,
		enabled = false,
	},
	{
		'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
		lazy = true,
		priority = 1000,
		name = 'rainbow-delimiters',
		enabled = false,
	},

	-- File Tree
	{
		'nvim-tree/nvim-tree.lua',
		priority = 1000,
		name = 'nvim-tree',
		dependencies = {
			'web-devicons',
			'antosha417/nvim-lsp-file-operations',
			'echasnovski/mini.base16',
		},
		config = function()
			return require('lazy_cfg.nvim_tree')
		end,
	},

	{ 'rhysd/vim-syntax-codeowners', lazy = false, name = 'codeowners-syntax' },

	{
		'lewis6991/gitsigns.nvim',
		name = 'GitSigns',
		version = '*',
		config = function()
			return require('lazy_cfg.gitsigns')
		end,
	},

	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		name = 'WhickKey',
		priority = 1000,
		init = function()
			set.timeout = true
			set.timeoutlen = 300
		end,
		config = function()
			return require('lazy_cfg.which_key')
		end,
	},

	{
		'norcalli/nvim-colorizer.lua',
		name = 'colorizer',
		config = function()
			return require('lazy_cfg.colorizer')
		end,
	},

	{
		'akinsho/toggleterm.nvim',
		priority = 1000,
		name = 'ToggleTerm',
		config = function()
			return require('lazy_cfg.toggleterm')
		end,
	},

	{
		'vhyrro/luarocks.nvim',
		priority = 1000,
		name = 'luarocks',
		config = true,
		enabled = false,
	},
	{
		'nvim-neorg/neorg',
		lazy = false,
		dependencies = {
			'luarocks',
			'treesitter',
		},
		verdion = '*',
		config = true,
		enabled = false,
	},
}, opts
)

---@type LazyMods
local M = {
	colorschemes = require('lazy_cfg.colorschemes'),
}

return M
