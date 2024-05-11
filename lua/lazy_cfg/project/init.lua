---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local maps_t = User.types.user.maps
local kmap = User.maps.kmap

local exists = Check.exists.module
local nmap = kmap.n

if not exists('project_nvim') then
	return
end

local stdpath = vim.fn.stdpath

local Project = require('project_nvim')
local Config = require('project_nvim.config')

local recent_proj = Project.get_recent_projects

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

	-- Don't calculate root dir on specific directories
	-- Ex: { "~/.cargo/*", ... }
	exclude_dirs = {
		'~/Templates/^'
	},

	-- Show hidden files in telescope
	show_hidden = true,

	-- When set to false, you will get a message when project.nvim changes your
	-- directory.
	silent_chdir = false,

	-- What scope to change the directory, valid options are
	-- * global (default)
	-- * tab
	-- * win
	scope_chdir = 'tab',

	-- Path where project.nvim will store the project history for use in
	-- telescope
	datapath = stdpath("data"),
}

Project.setup(opts)

---@type KeyMapDict
local keys = {
	['<leader>pr'] = {
		function()
			local msg = '\n'

			for _, v in next, recent_proj() do
				msg = msg .. '\n- ' .. v
			end
			if exists('notify') then
				require('notify')(msg, 'info', { title = 'Recent Projects' })
			else
				print(msg)
			end
		end,
		{ desc = 'Print Recent Projects' }
	}
}

for key, v in next, keys do
	nmap(key, v[1], v[2] or {})
end
