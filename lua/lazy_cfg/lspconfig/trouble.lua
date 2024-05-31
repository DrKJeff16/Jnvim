---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.lspconfig
local kmap = User.maps.kmap
local WK = User.maps.wk

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local desc = kmap.desc

if not exists('trouble') then
	return
end

local Trouble = require('trouble')

local toggle = Trouble.toggle

---@type trouble.Config
local Opts = {
	auto_open = false, -- automatically open the list when you have diagnostics
	auto_close = true, -- automatically close the list when you have no diagnostics
	auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
	auto_fold = true, -- automatically fold a file trouble list at creation
	auto_jump = { 'lsp_definitions' }, -- for the given modes, automatically jump if there is only a single result
	focus = false, -- Focus the window when opened
	restore = true, -- restores the last location in the list when opening
	follow = true, -- Follow the current item
	indent_guides = true, -- show indent guides
	max_items = 200, -- limit number of items that can be displayed per section
	multiline = true, -- render multi-line messages
	pinned = true, -- When pinned, the opened trouble window will be bound to the current buffer

	---@type trouble.Window.opts
	win = {}, -- window options for the results window. Can be a split or a floating window.
	-- Window options for the preview window. Can be a split, floating window,
	-- or `main` to show the preview in the main editor window.
	---@type trouble.Window.opts
	preview = {
		type = 'main',
		-- when a buffer is not yet loaded, the preview window will be created
		-- in a scratch buffer with only syntax highlighting enabled.
		-- Set to false, if you want the preview to always be a real loaded buffer.
		scratch = true,
	},
	-- Throttle/Debounce settings. Should usually not be changed.
	---@type table<string, number|{ms:number, debounce?:boolean}>
	throttle = {
		refresh = 20, -- fetches new data when needed
		update = 10, -- updates the window
		render = 10, -- renders the window
		follow = 100, -- follows the current item
		preview = { ms = 100, debounce = true }, -- shows the preview for the current item
	},
	-- Key mappings can be set to the name of a builtin action,
	-- or you can define your own custom action.
	---@type table<string, string|trouble.Action>
	keys = {
		['?'] = 'help',
		r = 'refresh',
		R = 'toggle_refresh',
		q = 'close',
		o = 'jump_close',
		['<Esc>'] = 'cancel',
		['<cr>'] = 'jump',
		['<2-leftmouse>'] = 'jump',
		['<c-s>'] = 'jump_split',
		['<c-v>'] = 'jump_vsplit',
		-- go down to next item (accepts count)
		-- j = "next",
		['}'] = 'next',
		[']]'] = 'next',
		-- go up to prev item (accepts count)
		-- k = "prev",
		['{'] = 'prev',
		['[['] = 'prev',
		i = 'inspect',
		p = 'preview',
		P = 'toggle_preview',
		zo = 'fold_open',
		zO = 'fold_open_recursive',
		zc = 'fold_close',
		zC = 'fold_close_recursive',
		za = 'fold_toggle',
		zA = 'fold_toggle_recursive',
		zm = 'fold_more',
		zM = 'fold_close_all',
		zr = 'fold_reduce',
		zR = 'fold_open_all',
		zx = 'fold_update',
		zX = 'fold_update_all',
		zn = 'fold_disable',
		zN = 'fold_enable',
		zi = 'fold_toggle_enable',
		gb = { -- example of a custom action that toggles the active view filter
			action = function(view)
				view.state.filter_buffer = not view.state.filter_buffer
				view:filter(view.state.filter_buffer and { buf = 0 } or nil)
			end,
			desc = 'Toggle Current Buffer Filter',
		},
	},
	---@type table<string, trouble.Mode>
	modes = {
		symbols = {
			desc = 'document symbols',
			mode = 'lsp_document_symbols',
			focus = false,
			win = { position = 'right' },
			filter = {
				-- remove Package since luals uses it for control flow structures
				['not'] = { ft = 'lua', kind = 'Package' },
				any = {
					-- all symbol kinds for help / markdown files
					ft = { 'help', 'markdown' },
					-- default set of symbol kinds
					kind = {
						'Class',
						'Constructor',
						'Enum',
						'Field',
						'Function',
						'Interface',
						'Method',
						'Module',
						'Namespace',
						'Package',
						'Property',
						'Struct',
						'Trait',
					},
				},
			},
		},
	},
	-- stylua: ignore
	icons = {
		---@type trouble.Indent.symbols
		indent = {
			top           = "│ ",
			middle        = "├╴",
			last          = "└╴",
			-- last          = "-╴",
			-- last       = "╰╴", -- rounded
			fold_open     = " ",
			fold_closed   = " ",
			ws            = "  ",
		},
		folder_closed   = " ",
		folder_open     = " ",
		kinds = {
			Array         = " ",
			Boolean       = "󰨙 ",
			Class         = " ",
			Constant      = "󰏿 ",
			Constructor   = " ",
			Enum          = " ",
			EnumMember    = " ",
			Event         = " ",
			Field         = " ",
			File          = " ",
			Function      = "󰊕 ",
			Interface     = " ",
			Key           = " ",
			Method        = "󰊕 ",
			Module        = " ",
			Namespace     = "󰦮 ",
			Null          = " ",
			Number        = "󰎠 ",
			Object        = " ",
			Operator      = " ",
			Package       = " ",
			Property      = " ",
			String        = " ",
			Struct        = "󰆼 ",
			TypeParameter = " ",
			Variable      = "󰀫 ",
		},
	},
}

Trouble.setup(Opts)

---@type table<MapModes, KeyMapDict>
local Keys = {
	n = {
		['<leader>xx'] = { toggle, desc('Toggle Trouble') },
		['<leader>xw'] = {
			function()
				toggle('workspace_diagnostics')
			end,
			desc('Toggle Workspace Diagnostics'),
		},
		['<leader>xd'] = {
			function()
				toggle('document_diagnostics')
			end,
			desc('Toggle Document Diagnostics'),
		},
		['<leader>xq'] = {
			function()
				toggle('quickfix')
			end,
			desc('Toggle Quickfix'),
		},
		['<leader>xl'] = {
			function()
				toggle('loclist')
			end,
			desc('Toggle Loclist'),
		},
		['<leader>xr'] = {
			function()
				toggle('lsp_references')
			end,
			desc('Toggle References'),
		},
	},
	v = {
		['<leader>xx'] = { toggle, desc('Toggle Trouble') },
		['<leader>xw'] = {
			function()
				toggle('workspace_diagnostics')
			end,
			desc('Toggle Workspace Diagnostics'),
		},
		['<leader>xd'] = {
			function()
				toggle('document_diagnostics')
			end,
			desc('Toggle Document Diagnostics'),
		},
		['<leader>xq'] = {
			function()
				toggle('quickfix')
			end,
			desc('Toggle Quickfix'),
		},
		['<leader>xl'] = {
			function()
				toggle('loclist')
			end,
			desc('Toggle Loclist'),
		},
		['<leader>xr'] = {
			function()
				toggle('lsp_references')
			end,
			desc('Toggle References'),
		},
	},
}
---@type table<MapModes, RegKeysNamed>
local Names = {
	n = { ['<leader>x'] = { name = '+Trouble' } },
	v = { ['<leader>x'] = { name = '+Trouble' } },
}

for mode, t in next, Keys do
	if WK.available() then
		if is_tbl(Names[mode]) and not empty(Names[mode]) then
			WK.register(Names[mode], { mode = mode })
		end

		WK.register(WK.convert_dict(t), { mode = mode })
	else
		for lhs, v in next, t do
			v[2] = is_tbl(v[2]) and v[2] or {}

			kmap[mode](t, v[1], v[2])
		end
	end
end
