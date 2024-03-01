---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  	vim.fn.system({
    	"git",
    	"clone",
    	"--filter=blob:none",
    	"https://github.com/folke/lazy.nvim.git",
    	"--branch=stable", -- latest stable release
    	lazypath,
  	})
end
vim.opt.rtp:prepend(lazypath)

local User = require('user')
local exists = User.exists

if not exists('lazy') then
	return
end

local pfx = 'lazy_cfg.'

local source_cfg = function(dir, prefx)
	prefx = prefx or pfx
	local path = prefx..dir

	if exists(path) then
		require(path)
	end
end

local Lazy = require('lazy')

Lazy.setup({
	{
		'folke/lazy.nvim',
		priority = 1000,
		event = 'VimEnter',
	},
	{
		'tpope/vim-commentary',
		lazy = false,
		priority = 660,
	},
	{
		'tpope/vim-endwise',
		lazy = false,
		priority = 750,
		event = 'InsertEnter',
	},
	{
		'vim-scripts/L9',
		lazy = true,
		priority = 1000,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		cmd = {
      		"TSInstall",
      		"TSUninstall",
      		"TSUpdate",
      		"TSUpdateSync",
      		"TSInstallInfo",
      		"TSInstallSync",
      		"TSInstallFromGrammar",
    	},
    	event = "User FileOpened",
		priority = 700,
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
		lazy = false,
		priority = 850,
		dependencies = {
			'folke/neodev.nvim',
		},
	},
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			local Tokyonight = require('tokyonight')

			Tokyonight.setup({
				style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  				transparent = false, -- Enable this to disable setting the background color
  				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
  				styles = {
  					comments = { italic = false },
  					keywords = { italic = false },
  					functions = {},
  					variables = {},
  					-- Background styles. Can be "dark", "transparent" or "normal"
  					sidebars = "dark", -- style for sidebars, see below
  					floats = "dark", -- style for floating windows
  				},
			})
			vim.cmd[[colorscheme tokyonight-night]]
		end,
	},
	{
		'lunarvim/lunar.nvim',
		lazy = true,
	},
	{
		'nvim-lua/plenary.nvim',
		lazy = true,
		cmd = {
			"PlenaryBustedFile",
			"PlenaryBustedDirectory",
		},
	},
	{
		'hrsh7th/nvim-cmp',
		priority = 1000,
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'neovim/nvim-lspconfig',
			'onsails/lspkind.nvim',
		    'L3MON4D3/LuaSnip',

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
			'folke/neodev.nvim',
		},
	},
	{
		'folke/neodev.nvim',
		lazy = false,
	},
	{ 'onsails/lspkind.nvim', lazy = false, priority = 8500 },
	{
		'L3MON4D3/LuaSnip',
		dependencies = { "rafamadriz/friendly-snippets" },
	},
	{ "rafamadriz/friendly-snippets", lazy = false },

	{'hrsh7th/cmp-nvim-lsp', lazy = false},
	{'hrsh7th/cmp-nvim-lua', lazy = false},
	{'hrsh7th/cmp-nvim-lsp-document-symbol', lazy = true },
	{'hrsh7th/cmp-nvim-lsp-signature-help', lazy = true },
	{'hrsh7th/cmp-buffer', lazy = true},
	{'hrsh7th/cmp-path', lazy = false},
	{'petertriho/cmp-git', lazy = true},
	{'FelipeLema/cmp-async-path', lazy = true},
	{'hrsh7th/cmp-cmdline', lazy = false},
	{'saadparwaiz1/cmp_luasnip', lazy = true},

	{
		"nvim-telescope/telescope.nvim",
    	lazy = true,
    	cmd = 'Telescope',
    	dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },

	{ 'nvim-tree/nvim-web-devicons', lazy = true, priority = 1000 },
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		priority = 1000,
	},

	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		priority = 450,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		lazy = true,
		dependencies = { 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim' },
	},

	{
    	"ahmedkhalf/project.nvim",
    	lazy = false,
    	event = "VimEnter",
    	cmd = "Telescope projects",
  	},
})

source_cfg('lualine')
source_cfg('cmp')
source_cfg('lspconfig')
source_cfg('treesitter')
source_cfg('autopairs')
source_cfg('blank_line')

vim.api.nvim_set_keymap('n', '<Leader>LL', ':Lazy<CR>', { noremap = true, silent = false })
