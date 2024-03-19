---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local User = require('user')
local exists = User.exists

if not exists('lazy') then
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
end

vim.opt.rtp:prepend(lazypath)

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
	{
		'folke/lazy.nvim',
		priority = 1000,
		event = 'VimEnter',
	},
	{
		'tpope/vim-commentary',
		priority = 660,
		event = 'InsertEnter',
	},
	{
		'tpope/vim-endwise',
		priority = 750,
		event = 'InsertEnter',
	},
	{ 'tpope/vim-fugitive', lazy = true },
	{ 'tpope/vim-speeddating', lazy = true },
	{ 'vim-scripts/L9', lazy = true },
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':verbose TSUpdate',
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
		priority = 750,
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
		priority = 850,
		dependencies = { 'folke/neodev.nvim' },
	},
	{ 'folke/neodev.nvim', lazy = true },

	{ "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = true },
	{
		'folke/tokyonight.nvim',
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
  					functions = { bold = true },
  					variables = {},
  					-- Background styles. Can be "dark", "transparent" or "normal"
  					sidebars = "dark", -- style for sidebars, see below
  					floats = "dark", -- style for floating windows
  				},
			})
			vim.cmd[[colorscheme tokyonight-night]]
		end,
	},
	{ 'lunarvim/lunar.nvim', lazy = true },
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
	{
		"lewis6991/hover.nvim",
    	config = function()
        	require("hover").setup {
            	init = function()
                	-- Require providers
                	if exists('lspconfig') then
                		require("hover.providers.lsp")
                	end
                	-- require('hover.providers.gh')
                	-- require('hover.providers.gh_user')
                	-- require('hover.providers.jira')
                	require('hover.providers.man')
                	-- require('hover.providers.dictionary')
            	end,
            	preview_opts = {
                	border = 'single'
            	},
            	-- Whether the contents of a currently open hover window should be moved
            	-- to a :h preview-window when pressing the hover keymap.
            	preview_window = false,
            	title = true,
            	mouse_providers = {
                	'LSP'
            	},
            	mouse_delay = 1000
        	}

        	-- Setup keymaps
        	vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
        	vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
        	vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
        	vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})

        	-- Mouse support
        	vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
        	vim.o.mousemoveevent = true
		end,
		event = 'User FileOpened',
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
	{ 'onsails/lspkind.nvim', lazy = false, priority = 8500 },
	{
		'L3MON4D3/LuaSnip',
		dependencies = { "rafamadriz/friendly-snippets" },
		build = 'make install_jsregexp',
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
    	lazy = true,
    	event = "VimEnter",
    	cmd = "Telescope projects",
  	},
})

source_cfg('lualine')
source_cfg('lspconfig')
source_cfg('cmp')
source_cfg('treesitter')
-- source_cfg('autopairs')
source_cfg('blank_line')

vim.api.nvim_set_keymap('n', '<Leader>lL', ':Lazy<CR>', { noremap = true, silent = true })
