---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('which-key') then
	return
end

local pfx = 'lazy_cfg.which_key.'

local WK = require('which-key')
local presets = require('which-key.plugins.presets')

---@alias ModeEnum
---| 'n'
---| 'v'
---| 'i'
---| 't'

---@alias KeyTbl
---|string[]
---|{ integer: string, integer:string, [string]: (boolean|integer) }
---|string
---|table<string, (string|fun(...): any)>

---@alias MapsTbl table<string, table<string, 'which_key_ignore'|any>>

---@class RegOpts
---@field mode? ModeEnum
---@field prefix string
---@field buffer? nil|integer
---@field silent? boolean
---@field noremap? boolean
---@field nowait? boolean
---@field expr? boolean

---@param maps table<(string|integer), any>
---@param opts? RegOpts
local reg = function(maps, opts)
	opts = opts or { noremap = true, nowait = true }
	local register = WK.register

	register(maps, opts)
end

local regs = {
	['<leader>f'] = {
		name = '+file',
		s = { '<CMD>w<cr>', 'Save File', noremap = true, silent = true, nowait = true },
		S = { '<CMD>w ', 'Save File Interactively', noremap = true, silent = false, nowait = true },

		i = {
			name = '+Indent',
			r = {
				'<CMD>%retab<cr>',
				'Retab',
				noremap = true,
				silent = true,
				nowait = true,
			},
		},

		f = {
			'<CMD>ed ',
			'Choose a buffer to edit interactively',
			silent = false,
			noremap = true,
			nowait = true,
		},

		t = {
			name = '+NvimTree',
			t = {
				'<CMD>NvimTreeOpen<cr>',
				'Open NvimTree',
				silent = true,
				nowait = true,
				noremap = true,
			},
			f = {
				'<CMD>NvimTreeFocus<cr>',
				'Focus NvimTree',
				silent = true,
				nowait = true,
				noremap = true,
			},
			d = {
				'<CMD>NvimTreeClose<cr>',
				'Close NvimTree',
				silent = true,
				nowait = true,
				noremap = true,
			},
		},
	},
	['<leader>b'] = {
		name = '+buffer',
		d = {
			'<CMD>bdel<cr>',
			'Close Buffer',
			silent = true,
			nowait = true,
			noremap = true,
		},
		D = {
			'<CMD>bdel!<cr>',
			'Close Buffer (Forcefully)',
			silent = true,
			nowait = true,
			noremap = true,
		},
		f = {
			'<CMD>bfirst<cr>',
			'Go To First Buffer',
			silent = true,
			nowait = true,
			noremap = true,
		},
		l = {
			'<CMD>blast<cr>',
			'Go To Last Buffer',
			silent = true,
			nowait = true,
			noremap = true,
		},
		n = {
			'<CMD>bNext<cr>',
			'Go To Next Buffer',
			silent = true,
			nowait = true,
			noremap = true,
		},
		p = {
			'<CMD>bprevious<cr>',
			'Go To Previous Buffer',
			silent = true,
			nowait = true,
			noremap = true,
		},
	},
	['<leader>h'] = { name = '+GitSigns' },
	['<leader>L'] = {
		name = '+Lazy',
		l = {
			'<CMD>Lazy ',
			'Run Lazy Interactively',
			silent = false,
			nowait = true,
			noremap = true,
		},
		L = {
			'<CMD>Lazy<cr>',
			'Open Lazy Menu',
			silent = true,
			nowait = true,
			noremap = true,
		},
		x = {
			'<CMD>Lazy clean<cr>',
			'Run Lazy Clean',
			silent = true,
			nowait = true,
			noremap = true,
		},
		s = {
			'<CMD>Lazy sync<cr>',
			'Run Lazy Sync',
			silent = true,
			nowait = true,
			noremap = true,
		},
		c = {
			'<CMD>Lazy check<cr>',
			'Run Lazy Check',
			silent = true,
			nowait = true,
			noremap = true,
		},
	},

	['<leader>o'] = {
		name = '+Orgmode',
		a = {
			'<CMD>org agenda<cr>',
			'Org Agenda',
			silent = true,
			nowait = true,
			noremap = true,
		},
		c = {
			'<CMD>org capture<cr>',
			'Org Capture',
			silent = true,
			nowait = true,
			noremap = true,
		},
	},
	 ['<leader>w'] = {
		name = '+Window',
		s = {
			name = '+Split',
			s = {
				'<CMD>split<cr>',
				'Split Window Horizontally',
				noremap = true,
				nowait = true,
			},
		},
	 },
}

reg(regs)
