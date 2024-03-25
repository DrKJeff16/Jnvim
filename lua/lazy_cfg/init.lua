---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local fn = vim.fn
local opt = vim.opt
local let = vim.g
local set = vim.o
local api = vim.api

local map = api.nvim_set_keymap

local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'

local User = require('user')
local exists = User.exists

if not exists('lazy') or not vim.loop.fs_stat(lazypath) then
  	fn.system({
    	'git',
    	'clone',
    	'--filter=blob:none',
    	'https://github.com/folke/lazy.nvim.git',
    	'--branch=stable', -- latest stable release
    	lazypath,
  	})
end

opt.rtp:prepend(lazypath)

---@type string
local pfx = 'lazy_cfg.'

local Lazy = require('lazy')

Lazy.setup({
	{ 'folke/lazy.nvim', priority = 1000 },

	{ 'tpope/vim-commentary', lazy = false },
	{ 'tpope/vim-endwise', lazy = false },
	{ 'tpope/vim-fugitive', lazy = false },
	{ 'tpope/vim-speeddating', lazy = true },

	{ 'vim-scripts/L9', lazy = false, priority = 1000 },

	{
		'nvim-treesitter/nvim-treesitter',
		lazy = true,
		build = ':verbose TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-orgmode/orgmode',
			'JoosepAlviste/nvim-ts-context-commentstring',
		},
	},
	{ 'nvim-treesitter/nvim-treesitter-context', lazy = true },
	{ 'nvim-orgmode/orgmode', lazy = true },
	{ 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },

	{
		'neovim/nvim-lspconfig',
		lazy = true,
		dependencies = { 'folke/neodev.nvim' },
	},
	{ 'folke/neodev.nvim', lazy = true, dependencies = { 'folke/neoconf.nvim' } },
	{ 'folke/neoconf.nvim', lazy = true },

	{ 'catppuccin/nvim', name = 'catppuccin', priority = 1000, lazy = true },
	{
		'folke/tokyonight.nvim',
		priority = 1000,
		config = function()
			local Tokyonight = require('tokyonight')

			Tokyonight.setup({
				style = 'night',
  				transparent = false,
  				terminal_colors = true,
  				styles = {
  					comments = { italic = false },
  					keywords = { italic = false },
  					functions = { bold = true },
  					variables = {},
  					sidebars = 'dark',
  					floats = 'dark',
  				},
			})

			vim.cmd[[colorscheme tokyonight-night]]
		end,
	},

	{
  		'folke/todo-comments.nvim',
  		dependencies = { 'nvim-lua/plenary.nvim' },
  		opts = {},
  		priority = 1000,
	},

	{
		'nvim-lua/plenary.nvim',
		lazy = true,
		cmd = {
			'PlenaryBustedFile',
			'PlenaryBustedDirectory',
		},
  		priority = 1000,
	},

	{
		'hrsh7th/nvim-cmp',
		lazy = true,
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'neovim/nvim-lspconfig',
			'onsails/lspkind.nvim',

		    'hrsh7th/cmp-nvim-lsp',
		    'hrsh7th/cmp-nvim-lua',
		    'hrsh7th/cmp-nvim-lsp-document-symbol',
		    'hrsh7th/cmp-nvim-lsp-signature-help',
		    'hrsh7th/cmp-buffer',
		    'hrsh7th/cmp-path',
		    'petertriho/cmp-git',
		    'FelipeLema/cmp-async-path',
		    'hrsh7th/cmp-cmdline',
		    'saadparwaiz1/cmp_luasnip',
		},
	},
	{ 'onsails/lspkind.nvim', lazy = true },

	{ 'hrsh7th/cmp-nvim-lsp', lazy = true },
	{ 'hrsh7th/cmp-nvim-lua', lazy = true },
	{ 'hrsh7th/cmp-nvim-lsp-document-symbol', lazy = true },
	{ 'hrsh7th/cmp-nvim-lsp-signature-help', lazy = true },
	{ 'hrsh7th/cmp-buffer', lazy = true },
	{ 'hrsh7th/cmp-path', lazy = true },
	{ 'petertriho/cmp-git', lazy = true },
	{ 'FelipeLema/cmp-async-path', lazy = true },
	{ 'hrsh7th/cmp-cmdline', lazy = true },
	{ 'saadparwaiz1/cmp_luasnip', lazy = true, dependencies = { 'L3MON4D3/LuaSnip' } },
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		dependencies = { 'rafamadriz/friendly-snippets' },
		build = 'make install_jsregexp',
	},
	{ 'rafamadriz/friendly-snippets', lazy = true },

	{
		'nvim-telescope/telescope.nvim',
    	lazy = true,
    	cmd = 'Telescope',
    	dependencies = { 'nvim-telescope/telescope-fzf-native.nvim' },
    	priority = 1000,
    	enabled = false,
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', lazy = true, enabled = false },
	{
		'ahmedkhalf/project.nvim',
		lazy = true,
		cmd = 'Telescope projects',
		priority = 300,
		enabled = false,
	},

	{ 'nvim-tree/nvim-web-devicons', lazy = true },
	{
		'nvim-lualine/lualine.nvim',
		lazy = true,
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		priority = 1000,
	},
	{
		'akinsho/bufferline.nvim',
		lazy = true,
		version = '*',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		priority = 1000,
	},

	{ 'windwp/nvim-autopairs', lazy = true, enabled = false },

	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		lazy = true,
		dependencies = { 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim' },
		enabled = false,
	},
	{
		'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
		lazy = true,
		enabled = false,
	},

	{
		'nvim-tree/nvim-tree.lua',
		lazy = true,
		priority = 1000,
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'antosha417/nvim-lsp-file-operations',
			'echasnovski/mini.base16',
		},
	},
	{ 'antosha417/nvim-lsp-file-operations', lazy = true },
	{ 'echasnovski/mini.base16', lazy = true },

	'rhysd/vim-syntax-codeowners',
})

local submods = {
	'lspconfig',
	'treesitter',
	-- 'autopairs',
	-- 'blank_line',
	'cmp',
	'lualine',
	'nvim_tree',
}

return submods
