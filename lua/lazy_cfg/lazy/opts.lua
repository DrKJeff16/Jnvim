---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local types = User.types.lazy

local fn = vim.fn
local set = vim.o
local opt = vim.opt
local g = vim.g

local exists = fn.exists
local has = fn.has
local stdpath = fn.stdpath

local Lazy = require('lazy')
local Util = require('lazy.util')

---@type LazyConfig
local M = {
	defaults = {
		lazy = false,  -- WARN: DO NOT SET TO TRUE.
		version = '*',
	},
	install = { missing = true },
	ui = {
		size = {
			width = 0.85,
			height = 0.70,
		},
		wrap = set.wrap,
		border = exists('+termguicolors') == 1 and 'double' or 'none',
		backdrop = 70,  -- Opacity
		title = 'L   A   Z   Y',
		title_pos = 'center',
		pills = true,

		browser = nil,
		throttle = 20,

		icons	= {
			cmd = " ",
			config = "",
			event = " ",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "󰒲 ",
			loaded = "●",
			not_loaded = "○",
			plugin = " ",
			runtime = " ",
			require = "󰢱 ",
			source = " ",
			start = " ",
			task = "✔ ",
			list = {
				"●",
				"➜",
				"★",
				"‒",
			},
		},

		-- TODO: Define `<localleader>` mappings.
		custom_keys = {
			['<localleader>t'] = {
				function(plugin)
					Util.float_term(nil, {
						cwd = plugin.dir
					})
				end,
				desc = 'Open Terminal In Plugin Dir',
			},
			['<localleader>'] = {
				function(plugin)
					Util.git_info(plugin.dir)
				end,
				desc = 'Retrieve a plugin\'s Git info.',
			},
		},
	},

	diff = { cmd = 'git' },

	checker = {
		enabled = true,
		notify = true,
		frequency = 1800,
		check_pinned = false,
	},

	change_detection = {
		enabled = true,
		notify = true,
	},

	performance = {
		cache = { enabled = true },
		reset_packpath = true,

		rtp = {
			reset = true,
			paths = {},
			disabled_plugins = {
				-- 'gzip',
				-- 'matchit',
				-- 'matchparen',
				'netrwPlugin',
				-- 'tarPlugin',
				-- 'tohtml',
				'tutor',
				-- 'zipPlugin',
			},
		},
	},

	readme = {
		enabled = true,
		root = stdpath('state')..'/lazy/readme',
		files = { 'README.md', 'lua/**/README.md' },
		skip_if_doc_exists = true,
	},

	state = stdpath('state')..'/lazy/state.json',
	build = { warn_on_override = true },

	profiling = { loader = true, require = true },
}

return M
