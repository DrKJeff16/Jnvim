---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local exists = Check.exists.module
local types = User.types.which_key

local is_nil = Check.value.is_nil
local is_str = Check.value.is_str

local WK = require('which-key')
local Presets = require('which-key.plugins.presets')

local Register = WK.register

---@param maps RegKeysTbl
---@param opts? RegOpts
local reg = function(maps, opts)
	local valid_modes = { 'n', 'i', 'v', 't', 'x', 'o' }

	opts = opts or {}
	for _, o in next, { 'noremap', 'nowait', 'silent' } do
		if is_nil(opts[o]) then
			opts[o] = true
		end
	end
	if not is_str(opts.mode) or not vim.tbl_contains(valid_modes, opts.mode) then
		opts.mode = 'n'
	end
	---@type RegKeysTbl
	local filtered = {}

	for s, v in next, maps do
		---@type RegKey|RegPfx
		local tbl = v
		if is_nil(tbl.name) then
			for _, o in next, { 'noremap', 'nowait', 'silent' } do
				if is_nil(tbl[o]) then
					tbl[o] = true
				end
			end
		else
			opts.nowait = false
		end

		filtered[s] = tbl
	end

	Register(filtered, opts)
end

---@type RegKeysTbl
local regs = {
	-- File Handling
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

	--- Source File Handling
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

	--- NvimTree
	['<leader>ft'] = { name = '+NvimTree' },
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

	-- Telescope
	['<leader>fT'] = { name = '+Telescope' },
	['<leader>fTb'] = { name = '+Builtins' },
	['<leader>fTe'] = { name = '+Extensions' },

	-- Tabs Handling
	['<leader>t'] = { name = '+Tabs' },
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

	-- TODO: Expand these keys.
	-- GitSigns
	['<leader>G'] = { name = '+GitSigns' },
	['<leader>Gh'] = { name = '+Hunks' },
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

	-- Lazy
	['<leader>L'] = { name = '+Lazy' },
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

	-- Window Handling
	['<leader>w'] = { name = '+Window' },
	-- Window Splitting
	['<leader>ws'] = { name = '+Split' },
	['<leader>wss'] = {
		'<CMD>split<cr>',
		'Split Horizontally',
	},
	['<leader>wsv'] = {
		'<CMD>vsplit<cr>',
		'Split Vertically',
	},

	-- Exiting
	['<leader>q'] = { name = '+Quit Nvim' },
	['<leader>qq'] = {
		'<CMD>qa<cr>',
		'Quit All',
	},
	['<leader>qQ'] = {
		'<CMD>qa!<cr>',
		'Quit All (Forcefully)',
	},

	-- TODO Comments
	['<leader>c'] = { name = '+TODO Comments' },
	-- `TODO` Handling
	['<leader>ct'] = { name = '+TODO' },
	['<leader>ctn'] = {
		'<CMD>lua require(\'todo-comments\').jump_next()<cr>',
		'Next \'TODO\'',
	},
	['<leader>ctp'] = {
		'<CMD>lua require(\'todo-comments\').jump_prev()<cr>',
		'Previous \'TODO\'',
	},
	-- `ERROR` Handling
	['<leader>ce'] = { name = '+ERROR' },
	['<leader>cen'] = {
		'<CMD>lua require(\'todo-comments\').jump_next({ keywords = { \'ERROR\' } })<cr>',
		'Next \'ERROR\'',
	},
	['<leader>cep'] = {
		'<CMD>lua require(\'todo-comments\').jump_prev({ keywords = { \'ERROR\' } })<cr>',
		'Previous \'ERROR\'',
	},
	-- `ERROR` Handling
	['<leader>cw'] = { name = '+WARNING' },
	['<leader>cwn'] = {
		'<CMD>lua require(\'todo-comments\').jump_next({ keywords = { \'WARNING\' } })<cr>',
		'Next \'WARNING\'',
	},
	['<leader>cwp'] = {
		'<CMD>lua require(\'todo-comments\').jump_prev({ keywords = { \'WARNING\' } })<cr>',
		'Previous \'WARNING\'',
	},

	-- ToggleTerm
	['<leader>T'] = { name = '+ToggleTerm' },

	['<leader>l'] = { name = '+LSP' },
	['<leader>lw'] = { name = '+Workspace' },
}

reg(regs)
