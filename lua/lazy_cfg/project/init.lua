---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local exists = User.check.exists.module

if not exists('project_nvim') then
	return
end

local fn = vim.fn

local stdpath = fn.stdpath

local Project = require('project_nvim')
local Config = require('project_nvim.config')

local opts = {
	-- Manual mode doesn't automatically change your root directory, so you have
	-- the option to manually do so using `:ProjectRoot` command.
	manual_mode = false,

	-- Methods of detecting the root directory. **"lsp"** uses the native neovim
	-- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
	-- order matters: if one is not detected, the other is used as fallback. You
	-- can also delete or rearangne the detection methods.
	detection_methods = { "lsp", "pattern" },

	-- All the patterns used to detect root dir, when **"pattern"** is in
	-- detection_methods
	patterns = {
		".git",
		'.github',
		"_darcs",
		".hg",
		".bzr",
		".svn",
		"Makefile",
		"package.json",
		'pyproject.toml',
		'.neoconf.json',
		'Pipfile',
		'Pipfile.lock',
		'tox.ini',
		'stylua.toml',
		'neoconf.json',
	},

	-- Table of lsp clients to ignore by name
	-- eg: { "efm", ... }
	ignore_lsp = {},

	-- Don't calculate root dir on specific directories
	-- Ex: { "~/.cargo/*", ... }
	exclude_dirs = {
		'~/.emacs.d/',
		'~/',
		'~/.build/*',
		'~/Templates/',
	},

	-- Show hidden files in telescope
	show_hidden = true,

	-- When set to false, you will get a message when project.nvim changes your
	-- directory.
	silent_chdir = true,

	-- What scope to change the directory, valid options are
	-- * global (default)
	-- * tab
	-- * win
	scope_chdir = 'global',

	-- Path where project.nvim will store the project history for use in
	-- telescope
	datapath = stdpath("data"),
}

Project.setup(opts)
