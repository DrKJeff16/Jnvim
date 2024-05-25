---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.which_key

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local empty = Check.value.empty

local WK = require('which-key')
local Presets = require('which-key.plugins.presets')

local register = WK.register

---@type fun(maps: RegKeys|RegKeysNamed, opts: RegOpts?)
local function reg(maps, opts)
	local MODES = { 'n', 'i', 'v', 't', 'x', 'o' }
	local DEFAULT_OPTS = { 'noremap', 'nowait', 'silent' }

	opts = is_tbl(opts) and opts or {}

	opts.mode = is_str(opts.mode) and vim.tbl_contains(MODES, opts.mode) and opts.mode or 'n'

	for _, o in next, DEFAULT_OPTS do
		if not is_bool(opts[o]) then
			opts[o] = (o ~= 'nowait') and true or false
		end
	end

	---@type RegKeysTbl
	local filtered = {}

	for s, v in next, maps do
		---@type RegKey|RegPfx
		local tbl = vim.deepcopy(v)

		for _, o in next, DEFAULT_OPTS do
			if not is_nil(v.name) and o == 'nowait' then
				tbl[o] = false
			else
				tbl[o] = is_bool(tbl[o]) and tbl[o] or true
			end
		end

		filtered[s] = tbl
	end

	register(filtered, opts)
end

---@type RegKeysNamed
local Names = {
	-- File Handling
	['<leader>f'] = { name = '+File' },
	--- Source File Handling
	['<leader>fv'] = { name = '+Vim Files' },
	--- `init.lua` Editing
	['<leader>fve'] = { name = '+Edit `init.lua`' },

	-- Tabs Handling
	['<leader>t'] = { name = '+Tabs' },

	-- Buffer Handling
	['<leader>b'] = { name = '+Buffer' },

	-- Window Handling
	['<leader>w'] = { name = '+Window' },

	-- Window Splitting
	['<leader>ws'] = { name = '+Split' },

	-- Exiting
	['<leader>q'] = { name = '+Quit Nvim' },

	-- Help
	['<leader>h'] = { name = '+Help' },

	-- Session
	['<leader>S'] = { name = '+Session' },

	-- Vim
	['<leader>v'] = { name = '+Vim' },
}

---@type RegKeys
local Regs = {
	-- File Handling
	['<leader>fs'] = {
		'<CMD>w<cr>',
		'Save File',
	},
	--- Source File Handling
	['<leader>fvs'] = {
		'<CMD>luafile $MYVIMRC<cr>',
		'Source Neovim\'s `init.lua`',
	},
	--- `init.lua` Editing
	['<leader>fvee'] = {
		'<CMD>ed $MYVIMRC<cr>',
		'Open `$MYVIMRC`',
	},
	['<leader>fvet'] = {
		'<CMD>tabnew $MYVIMRC<cr>',
		'Open `$MYVIMRC` in new Tab',
	},
	['<leader>fves'] = {
		'<CMD>split $MYVIMRC<cr>',
		'Open `$MYVIMRC` in Horizontal Window',
	},
	['<leader>fvev'] = {
		'<CMD>vsplit $MYVIMRC<cr>',
		'Open `$MYVIMRC` in Vertical Window',
	},

	-- Tabs Handling
	['<leader>td'] = {
		'<CMD>tabc<cr>',
		'Close Tab',
	},
	['<leader>tD'] = {
		'<CMD>tabc!<cr>',
		'Close Tab (Forcefully)',
	},
	['<leader>tA'] = {
		'<CMD>tabnew<cr>',
		'New Tab',
	},
	['<leader>tf'] = {
		'<CMD>tabfirst<cr>',
		'First Tab',
	},
	['<leader>tl'] = {
		'<CMD>tablast<cr>',
		'Last Tab',
	},
	['<leader>tn'] = {
		'<CMD>tabN<cr>',
		'Next Tab',
	},
	['<leader>tp'] = {
		'<CMD>tabp<cr>',
		'Previous Tab',
	},

	-- Buffer Handling
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
		'First Buffer',
	},
	['<leader>bl'] = {
		'<CMD>blast<cr>',
		'Last Buffer',
	},
	['<leader>bn'] = {
		'<CMD>bN<cr>',
		'Next Buffer',
	},
	['<leader>bp'] = {
		'<CMD>bp<cr>',
		'Previous Buffer',
	},

	-- Window Handling
	['<leader>wn'] = { '<C-w>w', 'Next Window' },
	-- Window Splitting
	['<leader>wss'] = {
		'<CMD>split<cr>',
		'Split Horizontally',
	},
	['<leader>wsv'] = {
		'<CMD>vsplit<cr>',
		'Split Vertically',
	},

	-- Exiting
	['<leader>qq'] = {
		'<CMD>qa<cr>',
		'Quit All',
	},
	['<leader>qQ'] = {
		'<CMD>qa!<cr>',
		'Quit All (Forcefully)',
	},
}

---@type fun(mod: string, names: RegKeysNamed, regs: RegKeys?)
local function add_if_module(mod, names, regs)
	if not (is_tbl(names) and not empty(names)) then
		return
	end

	-- If module exists and key table is valid
	if exists(mod) then
		for key, ops in next, names do
			Names[key] = ops
		end
		if is_tbl(regs) and not empty(regs) then
			for key, ops in next, regs do
				Regs[key] = ops
			end
		end
	end
end

-- Context
add_if_module('treesitter-context', {
	['<leader>C'] = { name = '+Context' },
})

-- NvimTree
add_if_module('nvim-tree', {
	['<leader>ft'] = { name = '+NvimTree' },
}, {
	['<leader>fto'] = {
		'<CMD>NvimTreeOpen<cr>',
		'Open Tree',
	},
	['<leader>ftt'] = {
		'<CMD>NvimTreeToggle<cr>',
		'Toggle Tree',
	},
	['<leader>ftf'] = {
		'<CMD>NvimTreeFocus<cr>',
		'Focus Tree',
	},
	['<leader>ftd'] = {
		'<CMD>NvimTreeClose<cr>',
		'Close Tree',
	},
})

-- Telescope
add_if_module('telescope', {
	['<leader>fT'] = { name = '+Telescope' },
	['<leader>fTb'] = { name = '+Builtins' },
	['<leader>fTe'] = { name = '+Extensions' },
})

-- TODO: Expand these keys.
--
-- GitSigns
add_if_module('gitsigns', {
	['<leader>G'] = { name = '+GitSigns' },
	['<leader>Gh'] = { name = '+Hunks' },
}, {
	['<leader>Ghd'] = {
		'<CMD>Gitsigns diffthis<cr>',
		'Diffthis',
	},
	['<leader>Ghp'] = {
		'<CMD>Gitsigns preview_hunk<cr>',
		'Preview Current Hunk',
	},
	['<leader>Ghs'] = {
		'<CMD>Gitsigns stage_hunk<cr>',
		'Stage Current Hunk',
	},
	['<leader>GhS'] = {
		'<CMD>Gitsigns stage_buffer<cr>',
		'Stage Current Buffer',
	},
	['<leader>Ghu'] = {
		'<CMD>Gitsigns undo_stage_hunk<cr>',
		'Un-Stage Current Hunk',
	},
})

-- Lazy
add_if_module('lazy', {
	['<leader>L'] = { name = '+Lazy' },
	['<leader>e'] = { name = '+Edit Lazy Config' },
}, {
	['<leader>Ll'] = {
		'<CMD>Lazy<cr>',
		'Open Floating Window',
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
	['<leader>Lp'] = {
		'<CMD>Lazy profile<cr>',
		'Profile',
	},
})

-- Trouble
add_if_module('trouble', {
	['<leader>x'] = { name = '+Trouble' },
})

-- Barbar
add_if_module('barbar', {
	['<leader>B'] = { name = '+Barbar' },
})

-- Project
add_if_module('project_nvim', {
	['<leader>p'] = { name = '+Project' },
})

-- LSP
add_if_module('lspconfig', {
	['<leader>l'] = { name = '+LSP' },
	['<leader>lw'] = { name = '+Workspace' },
})

-- ToggleTerm
add_if_module('toggleterm', {
	['<leader>T'] = { name = '+ToggleTerm' },
})

-- TODO Comments
add_if_module('todo-comments', {
	-- TODO Comments
	['<leader>c'] = { name = '+TODO Comments' },
	-- `TODO` Handling
	['<leader>ct'] = { name = '+TODO' },
	-- `ERROR` Handling
	['<leader>ce'] = { name = '+ERROR' },
	-- `ERROR` Handling
	['<leader>cw'] = { name = '+WARNING' },
}, {
	['<leader>ctn'] = {
		'<CMD>lua require(\'todo-comments\').jump_next()<cr>',
		'Next \'TODO\'',
	},
	['<leader>ctp'] = {
		'<CMD>lua require(\'todo-comments\').jump_prev()<cr>',
		'Previous \'TODO\'',
	},
	-- `ERROR` Handling
	['<leader>cen'] = {
		'<CMD>lua require(\'todo-comments\').jump_next({ keywords = { \'ERROR\' } })<cr>',
		'Next \'ERROR\'',
	},
	['<leader>cep'] = {
		'<CMD>lua require(\'todo-comments\').jump_prev({ keywords = { \'ERROR\' } })<cr>',
		'Previous \'ERROR\'',
	},
	-- `ERROR` Handling
	['<leader>cwn'] = {
		'<CMD>lua require(\'todo-comments\').jump_next({ keywords = { \'WARNING\' } })<cr>',
		'Next \'WARNING\'',
	},
	['<leader>cwp'] = {
		'<CMD>lua require(\'todo-comments\').jump_prev({ keywords = { \'WARNING\' } })<cr>',
		'Previous \'WARNING\'',
	},
})

reg(Names)
reg(Regs)

return reg
