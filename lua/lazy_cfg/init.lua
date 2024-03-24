---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local fn = vim.fn
local opt = vim.opt
local let = vim.g
local set = vim.o

local map = api.nvim_set_keymap

local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'

local User = require('user')
local exists = User.exists

if not exists('lazy') or not vim.loop.fs_stat(lazypath) then
  	fn.system({
    	"git",
    	"clone",
    	"--filter=blob:none",
    	"https://github.com/folke/lazy.nvim.git",
    	"--branch=stable", -- latest stable release
    	lazypath,
  	})
end

opt.rtp:prepend(lazypath)

---@type string
local pfx = 'lazy_cfg.'

---@param dir string
---@param prefx? string
local source_cfg = function(dir, prefx)
	prefx = prefx or pfx
	local path = prefx..dir

	if exists(path) then
		require(path)
	end
end

local Lazy = require('lazy')

Lazy.setup({
	{ 'folke/lazy.nvim', priority = 1000 },

	{ 'tpope/vim-commentary', lazy = false },
	{ 'tpope/vim-endwise', lazy = false },
	{ 'tpope/vim-fugitive', lazy = false },
	{ 'tpope/vim-speeddating', lazy = true },

	{ 'vim-scripts/L9', lazy = false },

	{
		'nvim-treesitter/nvim-treesitter',
		lazy = true,
		build = ':verbose TSUpdate',
		priority = 850,
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-orgmode/orgmode',
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
	{ 'nvim-treesitter/nvim-treesitter-context', lazy = true },
	{ 'nvim-orgmode/orgmode', lazy = true },
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },

	{
		'neovim/nvim-lspconfig',
		lazy = true,
		priority = 850,
		dependencies = { 'folke/neodev.nvim' },
	},
	{ 'folke/neodev.nvim', lazy = true, dependencies = { 'folke/neoconf.nvim' } },
	{ 'folke/neoconf.nvim', lazy = true },

	{ "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = true },
	{
		'folke/tokyonight.nvim',
		priority = 1000,
		config = function()
			local Tokyonight = require('tokyonight')

			Tokyonight.setup({
				style = "night",
  				transparent = false,
  				terminal_colors = true,
  				styles = {
  					comments = { italic = false },
  					keywords = { italic = false },
  					functions = { bold = true },
  					variables = {},
  					sidebars = "dark",
  					floats = "dark",
  				},
			})

			vim.cmd[[colorscheme tokyonight-night]]
		end,
	},

	{
  		"folke/todo-comments.nvim",
  		dependencies = { "nvim-lua/plenary.nvim" },
  		opts = {},
	},
	{
		'nvim-lua/plenary.nvim',
		lazy = true,
		cmd = {
			"PlenaryBustedFile",
			"PlenaryBustedDirectory",
		},
	},

	-- { "lewis6991/hover.nvim", lazy = true },

	{
		'hrsh7th/nvim-cmp',
		lazy = true,
		event = { 'InsertEnter', 'CmdlineEnter' },
		priority = 1000,
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'neovim/nvim-lspconfig',
			'onsails/lspkind.nvim',

		    "hrsh7th/cmp-nvim-lsp",
		    "hrsh7th/cmp-nvim-lua",
		    "hrsh7th/cmp-nvim-lsp-document-symbol",
		    "hrsh7th/cmp-nvim-lsp-signature-help",
		    "hrsh7th/cmp-buffer",
		    "hrsh7th/cmp-path",
		    "petertriho/cmp-git",
		    "FelipeLema/cmp-async-path",
		    "hrsh7th/cmp-cmdline",
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
		dependencies = { "rafamadriz/friendly-snippets" },
		build = 'make install_jsregexp',
	},
	{ "rafamadriz/friendly-snippets", lazy = true },

	{
		"nvim-telescope/telescope.nvim",
    	lazy = true,
    	cmd = 'Telescope',
    	dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },

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
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		lazy = true,
		dependencies = { 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim' },
		enabled = false,
	},

	{ "ahmedkhalf/project.nvim", lazy = true, cmd = "Telescope projects" },
})

source_cfg('lspconfig')
source_cfg('treesitter')
-- source_cfg('autopairs')
-- source_cfg('blank_line')
source_cfg('cmp')
source_cfg('lualine')

vim.api.nvim_set_keymap('n', '<Leader>Ll', ':Lazy<CR>', { noremap = true, silent = true })
