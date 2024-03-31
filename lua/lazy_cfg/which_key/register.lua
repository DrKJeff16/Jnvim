---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.which_key')

local User = require('user')
local exists = User.exists

if not exists('which-key') then
	return
end

local pfx = 'lazy_cfg.which_key.'

local WK = require('which-key')
local presets = require('which-key.plugins.presets')

---@param maps RegKeysTbl
---@param opts? RegOpts
local reg = function(maps, opts)
	opts = opts or { noremap = true, nowait = true }
	local register = WK.register

	---@type RegKeysTbl
	local filtered = {}

	for s, v in next, maps do
		---@type RegKey|RegPfx
		local tbl = v
		if not tbl.name then
			if not tbl.noremap then
				tbl.noremap = true
			end
			if not tbl.nowait then
				tbl.nowait = true
			end
			if not tbl.silent then
				tbl.silent = true
			end
		end

		filtered[s] = tbl
	end

	register(filtered, opts)
end

---@type RegKeysTbl
local regs = {
	['<leader>f'] = { name = '+File' },
	['<leader>fs'] = {
		'<CMD>w<cr>',
		'Save File',
	},
	['<leader>fi'] = { name = '+Indent' },
	['<leader>fir'] = {
		'<CMD>%retab<cr>',
		'Retab',
	},

	['<leader>fv'] = { name = '+Vim Files' },
	['<leader>fvs'] = {
		'<CMD>luafile $MYVIMRC<cr>',
		'Source Neovim\'s `init.lua`',
	},
	['<leader>fve'] = {
		'<CMD>tabnew $MYVIMRC<cr>',
		'Open A New Neovim\'s `init.lua` Tab',
	},
	['<leader>fvl'] = {
		'<CMD>luafile %<cr>',
		'Source The Current File With Lua',
	},
	['<leader>fvv'] = {
		'<CMD>so %<cr>',
		'Source The Current File With Vimscript',
	},

	['<leader>ft'] = { name = '+NvimTree' },
	['<leader>ftt'] = {
		'<CMD>NvimTreeOpen<cr>',
		'Open NvimTree',
	},
	['<leader>ftf'] = {
		'<CMD>NvimTreeFocus<cr>',
		'Focus NvimTree',
	},
	['<leader>ftd'] = {
		'<CMD>NvimTreeClose<cr>',
		'Close NvimTree',
	},

	['<leader>t'] = { name = '+Tabs' },
	['<leader>td'] = {
		'<CMD>tabclose<cr>',
		'Close Tab',
	},
	['<leader>tD'] = {
		'<CMD>tabclose!<cr>',
		'Close Tab (Forcefully)',
	},
	['<leader>tA'] = {
		'<CMD>tabnew<cr>',
		'Open New Tab',
	},
	['<leader>tf'] = {
		'<CMD>tabfirst<cr>',
		'Go To First Tab',
	},
	['<leader>tl'] = {
		'<CMD>tablast<cr>',
		'Go To Last Tab',
	},
	['<leader>tn'] = {
		'<CMD>tabNext<cr>',
		'Go To Next Tab',
	},
	['<leader>tp'] = {
		'<CMD>tabprev<cr>',
		'Go To Previous Tab',
	},

	['<leader>b'] = { name = '+Buffer' },
	['<leader>bd'] = {
		'<CMD>bdel<cr>',
		'Close Buffer',
	},
	['<leader>bD'] = {
		'<CMD>bdel!<cr>',
		'Close Buffer (Forcefully)',
	},
	['<leader>bf'] = {
		'<CMD>bfirst<cr>',
		'Go To First Buffer',
	},
	['<leader>bl'] = {
		'<CMD>blast<cr>',
		'Go To Last Buffer',
	},
	['<leader>bn'] = {
		'<CMD>bNext<cr>',
		'Go To Next Buffer',
	},
	['<leader>bp'] = {
		'<CMD>bprevious<cr>',
		'Go To Previous Buffer',
	},

	['<leader>h'] = { name = '+GitSigns' },

	['<leader>L'] = { name = '+Lazy' },
	['<leader>Ll'] = {
		'<CMD>Lazy<cr>',
		'Lazy',
	},
	['<leader>Lx'] = {
		'<CMD>Lazy clean<cr>',
		'Clean',
	},
	['<leader>Ls'] = {
		'<CMD>Lazy sync<cr>',
		'Sync',
	},
	['<leader>Lc'] = {
		'<CMD>Lazy check<cr>',
		'Check',
	},
	['<leader>Li'] = {
		'<CMD>Lazy install<cr>',
		'Install',
	},
	['<leader>Lr'] = {
		'<CMD>Lazy reload<cr>',
		'Reload',
	},

	['<leader>o'] = { name = '+Orgmode' },
	['<leader>oa'] = {
		'<CMD>org agenda<cr>',
		'Org Agenda',
	},
	['<leader>oc'] = {
		'<CMD>org capture<cr>',
		'Org Capture',
	},

	['<leader>w'] = { name = '+Window' },
	['<leader>ws'] = { name = '+Split' },
	['<leader>wss'] = {
		'<CMD>split<cr>',
		'Split Window Horizontally',
	},
	['<leader>wsv'] = {
		'<CMD>vsplit<cr>',
		'Split Window Vertically',
	},

	['<leader>q'] = { name = '+Quitting Nvim' },
	['<leader>qq'] = {
		'<CMD>qa<cr>',
		'Quit All Of Nvim Tabs',
	},
	['<leader>qQ'] = {
		'<CMD>qa!<cr>',
		'Quit All Of Nvim Tabs (Forcefully)',
	},

	['<leader>c'] = { name = '+TODO Comments' },
	['<leader>ct'] = { name = '+TODO' },
	['<leader>ctn'] = {
		'<CMD>lua require(\'todo-comments\').jump_next()<cr>',
		'Next \'TODO\' Comment',
	},
	['<leader>ctp'] = {
		'<CMD>lua require(\'todo-comments\').jump_prev()<cr>',
		'Previous \'TODO\' Comment',
	},
	['<leader>ce'] = { name = '+ERROR' },
	['<leader>cen'] = {
		'<CMD>lua require(\'todo-comments\').jump_next({ keywords = { \'ERROR\' } })<cr>',
		'Next \'ERROR\' Comment',
	},
	['<leader>cep'] = {
		'<CMD>lua require(\'todo-comments\').jump_prev({ keywords = { \'ERROR\' } })<cr>',
		'Previous \'ERROR\' Comment',
	},
	['<leader>cw'] = { name = '+WARNING' },
	['<leader>cwn'] = {
		'<CMD>lua require(\'todo-comments\').jump_next({ keywords = { \'WARNING\' } })<cr>',
		'Next \'WARNING\' Comment',
	},
	['<leader>cwp'] = {
		'<CMD>lua require(\'todo-comments\').jump_prev({ keywords = { \'WARNING\' } })<cr>',
		'Previous \'WARNING\' Comment',
	},

	['<leader>T'] = { name = '+ToggleTerm' },
}

reg(regs)
