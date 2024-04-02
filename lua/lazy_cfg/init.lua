---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types')
require('user.types.lazy')
require('user.types.colorschemes')

local fn = vim.fn
local opt = vim.opt
local let = vim.g
local set = vim.o
local api = vim.api

local rtp = opt.rtp
local fs_stat = vim.loop.fs_stat

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

-- Set installation dir for `Lazy`.
local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'

local User = require('user')
local exists = User.exists

-- Install `Lazy` automatically.
if not exists('lazy') or not fs_stat(lazypath) then
	fn.system({
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

Lazy.setup({
	{ 'folke/lazy.nvim', priority = 1000 },

	{ 'vim-scripts/L9', lazy = false, priority = 1000 },

	{
		'nvim-lua/plenary.nvim',
		lazy = true,
		priority = 1000,
		cmd = {
			'PlenaryBustedFile',
			'PlenaryBustedDirectory',
		},
	},
	{
		'nvim-lua/popup.nvim',
		lazy = true,
		priority = 1000,
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	{ 'nvim-tree/nvim-web-devicons', lazy = true, priority = 1000 },

	-- { 'tpope/vim-commentary', lazy = false },
	{
		'numToStr/Comment.nvim',
		lazy = true,
		name = 'Comment',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'JoosepAlviste/nvim-ts-context-commentstring',
		},
	},

	-- Tpope is god.
	{ 'tpope/vim-endwise', lazy = false },
	{ 'tpope/vim-fugitive', lazy = false, name = 'Fugitive' },
	{ 'tpope/vim-speeddating', lazy = true },

	-- Treesitter.
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = true,
		build = ':verbose TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-orgmode/orgmode',
			'JoosepAlviste/nvim-ts-context-commentstring',
			'HiPhish/nvim-ts-rainbow2',
		},
	},
	{ 'nvim-treesitter/nvim-treesitter-context', lazy = true },
	{ 'nvim-orgmode/orgmode', lazy = true },
	{ 'HiPhish/nvim-ts-rainbow2', lazy = true, enabled = false },
	{ 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },

	-- LSP
	{
		'neovim/nvim-lspconfig',
		lazy = true,
		dependencies = {
			'folke/neodev.nvim',
			'folke/neoconf.nvim',
			'b0o/SchemaStore.nvim',
			'p00f/clangd_extensions.nvim',
		},
	},
	-- Essenyial for Nvim Lua files.
	{
		'folke/neodev.nvim',
		lazy = true,
		priority = 1000,
		enabled = fn.executable('lua-language-server') == 1
	},
	{ 'folke/neoconf.nvim', lazy = true, enabled = false },
	{ 'b0o/SchemaStore.nvim', lazy = true },
	{ 'p00f/clangd_extensions.nvim', lazy = true, enabled = fn.executable('clangd') == 1 },

	-- Colorschemes
	{
		'pineapplegiant/spaceduck',
		lazy = false,
		priority = 1000,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			vim.g.installed_spaceduck = 1
		end,
	},
	{ 'catppuccin/nvim', lazy = true, priority = 1000, name = 'catppuccin' },
	{ 'folke/tokyonight.nvim', lazy = true, priority = 1000, name = 'tokyonight' },
	{ 'vigoux/oak', lazy = true, priority = 1000 },
	{
		'bkegley/gloombuddy',
		lazy = true,
		priority = 1000,
		dependencies = { 'tjdevries/colorbuddy.vim' },
	},
	{ 'tjdevries/colorbuddy.vim', lazy = true, priority = 1000, name = 'colorbuddy' },
	{ 'EdenEast/nightfox.nvim', lazy = true, priority = 1000, name = 'nightfox' },

	{
		'folke/todo-comments.nvim',
		lazy = true,
		priority = 1000,
		name = 'TODO-comments',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'nvim-lua/plenary.nvim',
		},
	},

	-- Completion Engine
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
			'davidsierradz/cmp-conventionalcommits',
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
	-- Git Completion
	{ 'petertriho/cmp-git', lazy = true },
	{ 'davidsierradz/cmp-conventionalcommits', lazy = true },
	{ 'FelipeLema/cmp-async-path', lazy = true },
	{ 'hrsh7th/cmp-cmdline', lazy = true },
	-- Snippet Engine
	{ 'saadparwaiz1/cmp_luasnip', lazy = true, dependencies = { 'L3MON4D3/LuaSnip' } },
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		dependencies = { 'rafamadriz/friendly-snippets' },
		build = 'make install_jsregexp',
	},
	-- Various Snippets
	{ 'rafamadriz/friendly-snippets', lazy = true },

	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		lazy = true,
		priority = 1000,
		cmd = 'Telescope',
		dependencies = {
			'nvim-telescope/telescope-fzf-native.nvim',
			'nvim-treesitter/nvim-treesitter',
			'neovim/nvim-lspconfig',
			'nvim-lua/plenary.nvim',
		},
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		lazy = true,
		build = 'make -j4',
	},
	-- Project Manager
	{
		'ahmedkhalf/project.nvim',
		lazy = true,
		priority = 1000,
	},

	-- Statusline
	{
		'nvim-lualine/lualine.nvim',
		lazy = true,
		priority = 1000,
		name = 'LuaLine',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
	},
	{
		'akinsho/bufferline.nvim',
		lazy = true,
		priority = 1000,
		name = 'BufferLine',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
	},

	-- Auto-pairing (**BROKEN**)
	{ 'windwp/nvim-autopairs', lazy = true, name = 'AutoPairs', enabled = false },

	{
		'lukas-reineke/indent-blankline.nvim',
		lazy = true,
		main = 'ibl',
		name = 'indent-blankline',
		dependencies = { 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim' },
		enabled = false,
	},
	{
		'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
		lazy = true,
		enabled = false,
	},

	-- File Tree
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
	{ 'echasnovski/mini.base16', lazy = true, priority = 1000 },

	{ 'rhysd/vim-syntax-codeowners', name = 'codeowners-syntax' },

	{ 'lewis6991/gitsigns.nvim', lazy = true, priority = 1000 },

	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		priority = 1000,
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},

	{
		'norcalli/nvim-colorizer.lua',
		lazy = true,
		priority = 1000,
		name = 'colorizer',
	},

	{
		'akinsho/toggleterm.nvim',
		lazy = true,
		priority = 1000,
		name = 'ToggleTerm',
	},
})

---@type LazyMods
local M = {
	colorschemes = function()
		return require('lazy_cfg.colorschemes')
	end,
	treesitter = function()
		return require('lazy_cfg.treesitter')
	end,
	lspconfig = function()
		return require('lazy_cfg.lspconfig')
	end,
	cmp = function()
		return require('lazy_cfg.cmp')
	end,
	Comment = function()
		return require('lazy_cfg.Comment')
	end,
	colorizer = function()
		return require('lazy_cfg.colorizer')
	end,
	todo_comments = function()
		return require('lazy_cfg.todo_comments')
	end,
	nvim_tree = function()
		return require('lazy_cfg.nvim_tree')
	end,
	gitsigns = function()
		return require('lazy_cfg.gitsigns')
	end,
	toggleterm = function()
		return require('lazy_cfg.toggleterm')
	end,
	lualine = function()
		return require('lazy_cfg.lualine')
	end,
	telescope = function()
		return require('lazy_cfg.telescope')
	end,
	-- NOTE: Must be last call
	which_key = function()
		return require('lazy_cfg.which_key')
	end,
}

return M
