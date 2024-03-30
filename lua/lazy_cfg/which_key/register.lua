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
		name = '+File',
		s = {
			'<CMD>w<cr>',
			'Save File',
			noremap = true,
			silent = true,
			nowait = true,
		},
	},
	['<leader>fi'] = {
		name = '+Indent',
		r = {
			'<CMD>%retab<cr>',
			'Retab',
			noremap = true,
			silent = true,
			nowait = true,
		},
	},
	['<leader>ft'] = {
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
	['<leader>t'] = {
		name = '+Tabs',
		d = {
			'<CMD>tabclose<cr>',
			'Close Tab',
			silent = true,
			nowait = true,
			noremap = true,
		},
		D = {
			'<CMD>tabclose!<cr>',
			'Close Tab (Forcefully)',
			silent = true,
			nowait = true,
			noremap = true,
		},
		A = {
			'<CMD>tabnew<cr>',
			'Open New Tab',
			silent = true,
			nowait = true,
			noremap = true,
		},
		f = {
			'<CMD>tabfirst<cr>',
			'Go To First Tab',
			silent = true,
			nowait = true,
			noremap = true,
		},
		l = {
			'<CMD>tablast<cr>',
			'Go To Last Tab',
			silent = true,
			nowait = true,
			noremap = true,
		},
		n = {
			'<CMD>tabNext<cr>',
			'Go To Next Tab',
			silent = true,
			nowait = true,
			noremap = true,
		},
		p = {
			'<CMD>tabprev<cr>',
			'Go To Previous Tab',
			silent = true,
			nowait = true,
			noremap = true,
		},
	},
	['<leader>b'] = {
		name = '+Buffer',
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
			'<CMD>Lazy<cr>',
			'Run Lazy Interactively',
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
	['<leader>w'] = { name = '+Window' },
	['<leader>ws'] = {
		name = '+Split',
		s = {
			'<CMD>split<cr>',
			'Split Window Horizontally',
			noremap = true,
			nowait = true,
			silent = true,
		},
		v = {
			'<CMD>vsplit<cr>',
			'Split Window Vertically',
			noremap = true,
			nowait = true,
			silent = true,
		},
	},
	['<leader>q'] = {
		name = '+Quitting Nvim',
		q = {
			'<CMD>qa<cr>',
			'Quit All Of Nvim Tabs',
			noremap = true,
			silent = true,
			nowait = true,
		},
		Q = {
			'<CMD>qa!<cr>',
			'Quit All Of Nvim Tabs (Forcefully)',
			noremap = true,
			silent = true,
			nowait = true,
		},
	},
}

reg(regs)
