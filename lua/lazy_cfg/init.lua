---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local fn = vim.fn
local opt = vim.opt
local let = vim.g
local set = vim.o
local api = vim.api

local rtp = opt.rtp
local fs_stat = vim.loop.fs_stat

local map = api.nvim_set_keymap
local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'

local User = require('user')
local exists = User.exists

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

rtp:prepend(lazypath)

local pfx = 'lazy_cfg.'

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

	{ 'nvim-tree/nvim-web-devicons', lazy = true, priority = 1000 },

	{ 'tpope/vim-commentary', lazy = false },
	{ 'tpope/vim-endwise', lazy = false },
	{ 'tpope/vim-fugitive', lazy = false, name = 'Fugitive' },
	{ 'tpope/vim-speeddating', lazy = true, enabled = false },

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
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		lazy = true,
	},

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
	{
		'folke/neodev.nvim',
		lazy = true,
		priority = 1000,
	},
	{ 'folke/neoconf.nvim', lazy = true },
	{ 'b0o/SchemaStore.nvim', lazy = true },
	{ 'p00f/clangd_extensions.nvim', lazy = true },

	{ 'catppuccin/nvim', lazy = true, priority = 1000, name = 'catppuccin' },
	{ 'folke/tokyonight.nvim', lazy = true, priority = 1000, name = 'tokyonight' },

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
	{ 'onsails/lspkind.nvim', lazy = true, priority = 1000 },

	{ 'hrsh7th/cmp-nvim-lsp', lazy = true },
	{ 'hrsh7th/cmp-nvim-lua', lazy = true },
	{ 'hrsh7th/cmp-nvim-lsp-document-symbol', lazy = true },
	{ 'hrsh7th/cmp-nvim-lsp-signature-help', lazy = true },
	{ 'hrsh7th/cmp-buffer', lazy = true },
	{ 'hrsh7th/cmp-path', lazy = true },
	{ 'petertriho/cmp-git', lazy = true },
	{ 'davidsierradz/cmp-conventionalcommits', lazy = true },
	{ 'FelipeLema/cmp-async-path', lazy = true },
	{ 'hrsh7th/cmp-cmdline', lazy = true },
	{ 'saadparwaiz1/cmp_luasnip', lazy = true, dependencies = { 'L3MON4D3/LuaSnip' } },
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		dependencies = { 'rafamadriz/friendly-snippets' },
		build = 'verbose make install_jsregexp',
	},
	{ 'rafamadriz/friendly-snippets', lazy = true },

	{
		'nvim-telescope/telescope.nvim',
		lazy = true,
		priority = 1000,
		cmd = 'Telescope',
		dependencies = { 'nvim-telescope/telescope-fzf-native.nvim' },
		enabled = false,
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		lazy = true,
		build = 'verbose make',
		enabled = false,
	},
	{
		'ahmedkhalf/project.nvim',
		lazy = true,
		priority = 1000,
		enabled = false,
	},

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
		-- lazy = true,
		event = 'VeryLazy',
		priority = 1000,
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},
})

---@type string[]
local submods = {
	'treesitter',
	'lspconfig',
	'cmp',
	'todo_comments',
	'nvim_tree',
	'gitsigns',
	'lualine',
	'which_key',  -- NOTE: Must be last call
}

return submods
