---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists
local types = User.types.lazy
local nmap = User.maps.kmap.n

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

-- Install `Lazy` automatically.
if not exists('lazy') or not fs_stat(lazypath) then
	system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		-- '--branch=stable',
		lazypath,
	})
end

-- Add `Lazy` to `stdpath`
rtp:prepend(lazypath)

local Lazy = require('lazy')
local Opts = require('lazy_cfg.lazy.opts')

---@alias LazyPlugs (string|LazyConfig|LazyPluginSpec|LazySpecImport|string|LazyPluginSpec|LazySpecImport|string|LazyPluginSpec|LazySpecImport[][])[]

--- A `config` function to call your plugins.
--- ---
---
--- Param `mod_str` must comply with this format:
--- ```lua
--- 'lazy_cfg.<plugin_name>[.<...>]'
--- ```
--- ---
---@param mod_str string
---@return fun(): any
local source = function(mod_str)
	return function() require(mod_str) end
end

---@type table<string, LazyPlugs>
local M = {}

---@type LazyPlugs
M.ESSENTIAL = {
	{ 'vim-scripts/L9', lazy = false, priority = 1000 },

	{
		'tiagovla/scope.nvim',
		lazy = false,
		priority = 1000,
		name = 'Scope',
		init = function()
			opt.ls = 2
			opt.stal = 2
		end,
		config = source('lazy_cfg.scope'),
	},

	{
		'nvim-lua/plenary.nvim',
		lazy = true,
		priority = 1000,
		name = 'Plenary',
	},
	{
		'nvim-lua/popup.nvim',
		lazy = false,
		priority = 1000,
		name = 'Popup',
		dependencies = { 'Plenary' },
	},

	{ 'nvim-tree/nvim-web-devicons', lazy = true, priority = 1000, name = 'web-devicons' },
}
---@type LazyPlugs
M.TS = {
	-- Treesitter.
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		priority = 1000,
		name = 'treesitter',
		build = ':verbose TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'JoosepAlviste/nvim-ts-context-commentstring',
		},
		config = source('lazy_cfg.treesitter'),
	},
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		name = 'ts-commentstring',
	},
}
---@type LazyPlugs
M.EDITING = {
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
		config = source('lazy_cfg.Comment'),
		enabled = function()
			return not let.commentary_installed and let.commentary_installed ~= 1
		end
	},

	{ 'tpope/vim-endwise', lazy = false },
	{ 'tpope/vim-fugitive', lazy = false, name = 'Fugitive', enabled = executable('git') == 1 },
	{ 'tpope/vim-speeddating', enabled = false },
	-- TODO COMMENTS
	{
		'folke/todo-comments.nvim',
		name = 'todo-comments',
		dependencies = {
			'treesitter',
			'Plenary',
		},
		config = source('lazy_cfg.todo_comments'),
	},
	{
		'windwp/nvim-autopairs',
		name = 'AutoPairs',
		config = source('lazy_cfg.autopairs'),
		enabled = false,
	},
	{
		'lewis6991/gitsigns.nvim',
		name = 'GitSigns',
		version = '*',
		config = source('lazy_cfg.gitsigns'),
	},
}
---@type LazyPlugs
M.LSP = {
	-- LSP
	{
		'neovim/nvim-lspconfig',
		lazy = false,
		name = 'lspconfig',
		dependencies = {
			'NeoDev',
			'NeoConf',
			'Trouble',
			'b0o/SchemaStore.nvim',
			'p00f/clangd_extensions.nvim',
		},
		config = source('lazy_cfg.lspconfig'),
	},
	-- Essenyial for Nvim Lua files.
	{
		'folke/neodev.nvim',
		lazy = false,
		priority = 1000,
		name = 'NeoDev',
		dependencies = { 'NeoConf' },
		enabled = executable('lua-language-server') == 1,
	},
	{
		'folke/neoconf.nvim',
		lazy = false,
		priority = 1000,
		name = 'NeoConf',
		dependencies = {
			'nlsp-settings',
		},
	},
	{
		'folke/trouble.nvim',
		lazy = true,
		name = 'Trouble',
		dependencies = { 'web-devicons' },
	},
	{
		'p00f/clangd_extensions.nvim',
		ft = { 'c', 'cpp' },
		enabled = function()
			return executable('clangd') == 1
		end,
	},
	{
		'tamago324/nlsp-settings.nvim',
		lazy = true,
		name = 'nlsp-settings',
		dependencies = {
			'MasonLSP',
			'Notify',
		},
		enabled = false,
	},
	{
		'williamboman/mason-lspconfig.nvim',
		lazy = true,
		name = 'MasonLSP',
		dependencies = { 'Mason' },
	},
	{
		'williamboman/mason.nvim',
		cmd = { 'Mason' },
		name = 'Mason',
	},
	{
		'antosha417/nvim-lsp-file-operations',
		lazy = true,
		name = 'Lsp_FileOps',
	},
}
---@type LazyPlugs
M.COLORSCHEMES = {
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
	{
		'dracula/vim',
		lazy = false,
		priority = 1000,
		name = 'dracula',
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			let.installed_dracula = 1
		end,
	},
	{
		'liuchengxu/space-vim-dark',
		lazy = false,
		priority = 1000,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			let.installed_space_vim_dark = 1
		end,
	},
	{
		'tomasr/molokai',
		lazy = false,
		priority = 1000,
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			let.installed_molokai = 1
		end,
	},
	{
		'colepeters/spacemacs-theme.vim',
		lazy = false,
		priority = 1000,
		name = 'spacemacs',
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			let.installed_spacemacs = 1
		end,
	},
	{
		'joshdick/onedark.vim',
		lazy = false,
		priority = 1000,
		name = 'onedark',
		-- Set the global condition for a later
		-- submodule call.
		init = function()
			let.installed_onedark = 1
		end,
	},
	{
		'catppuccin/nvim',
		lazy = true,
		priority = 1000,
		name = 'catppuccin',
		main = 'catppuccin',
	},
	{
		'folke/tokyonight.nvim',
		lazy = true,
		priority = 1000,
		name = 'tokyonight',
		main = 'tokyonight',
	},
	{
		'vigoux/oak',
		lazy = true,
		priority = 1000,
	},
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
}
---@type LazyPlugs
M.CMP = {
	-- Completion Engine
	{
		'hrsh7th/nvim-cmp',
		event = { 'InsertEnter', 'CmdlineEnter' },
		priority = 1000,
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
		config = source('lazy_cfg.cmp')
	},
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		dependencies = { 'friendly-snippets' },
		-- TODO: Check whether `nproc` exists in `PATH`.
		build = (_G.is_windows and 'mingw32-make -j"$(nproc)" install_jsregexp' or 'make -j"$(nproc)" install_jsregexp'),
	},
	{ 'rafamadriz/friendly-snippets', lazy = false },
}
---@type LazyPlugs
M.TELESCOPE = {
	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		name = 'Telescope',
		dependencies = {
			'Telescope-fzf',
			'treesitter',
			'lspconfig',
			'Plenary',
			'Project',
		},
		config = source('lazy_cfg.telescope'),
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		lazy = true,
		name = 'Telescope-fzf',
		-- TODO: Check whether `nproc` exists in `PATH`.
		build = (_G.is_windows and 'mingw32-make -j"$(nproc)"' or 'make -j"$(nproc)"'),
		enabled = function()
			return executable('fzf') == 1
		end,
	},
	-- Project Manager
	{
		'ahmedkhalf/project.nvim',
		priority = 1000,
		name = 'Project',
		init = function()
			opt.ls = 2
			opt.stal = 2
		end,
		config = source('lazy_cfg.project'),
	},
}
---@type LazyPlugs
M.UI = {
	{
		'rcarriga/nvim-notify',
		lazy = false,
		name = 'Notify',
		dependencies = { 'Plenary' },
		init = function()
			opt.termguicolors = true
		end,
		config = source('lazy_cfg.notify'),
	},
	-- Statusline
	{
		'nvim-lualine/lualine.nvim',
		priority = 1000,
		name = 'LuaLine',
		dependencies = { 'web-devicons' },
		config = source('lazy_cfg.lualine'),
	},
	{
		'akinsho/bufferline.nvim',
		priority = 1000,
		name = 'BufferLine',
		dependencies = {
			'web-devicons',
			'Scope',
		},
		init = function()
			opt.termguicolors = true
		end,
		config = function()
			if exists('lazy_cfg.lualine.bufferline') then
				return require('lazy_cfg.lualine.bufferline')
			end

			return require('lazy_cfg.bufferline')
		end,
		enabled = false,
	},
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		name = 'ibl',
		dependencies = { 'rainbow-delimiters' },
		config = source('lazy_cfg.blank_line'),
		-- enabled = false,
	},
	{
		'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
		lazy = true,
		priority = 1000,
		name = 'rainbow-delimiters',
	},
	-- File Tree
	{
		'nvim-tree/nvim-tree.lua',
		priority = 1000,
		name = 'nvim-tree',
		dependencies = {
			'web-devicons',
			'Lsp_FileOps',
			'mini.base16',
		},
			-- Disable `netrw`.
		init = function()
			let.loaded_netrw = 1
			let.loaded_netrwPlugin = 1
		end,
		config = source('lazy_cfg.nvim_tree'),
	},
	{ 'echasnovski/mini.base16', lazy = true },
	{
		'norcalli/nvim-colorizer.lua',
		name = 'colorizer',
		config = source('lazy_cfg.colorizer'),
	},
	{
		'akinsho/toggleterm.nvim',
		name = 'ToggleTerm',
		config = source('lazy_cfg.toggleterm'),
	},
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		name = 'which_key',
		priority = 1000,
		init = function()
			set.timeout = true
			set.timeoutlen = 300
		end,
		config = source('lazy_cfg.which_key'),
	},
}

---@type LazyPlugs
M.SYNTAX = {
	{
		'rhysd/vim-syntax-codeowners',
		lazy = false,
		name = 'codeowners-syntax'
	},
}

---@type LazyPlugs
local T = {}

--- INFO: Setup.
for _, plugs in next, M do
	for _, p in next, plugs do
		table.insert(T, p)
	end
end
Lazy.setup(T)

---@type LazyMods
local P = {
	colorschemes = require('lazy_cfg.colorschemes'),
}

nmap('<leader>Le', function()
	local path = stdpath('config') .. '/lua/lazy_cfg/init.lua'

	vim.cmd('tabnew ' .. path)
end, { desc = 'Open `Lazy` File' })

return P
