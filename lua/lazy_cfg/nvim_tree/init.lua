---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local kmap = User.maps.kmap
local types = User.types.nvim_tree

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun
local is_num = Check.value.is_num
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local empty = Check.value.empty
local hi = User.highlight.hl

local nmap = kmap.n

if not exists('nvim-tree') then
	return
end

local api = vim.api
local opt = vim.opt
local fn = vim.fn
local bo = vim.bo

local sched = vim.schedule
local sched_wp = vim.schedule_wrap
local in_tbl = vim.tbl_contains
local filter = vim.tbl_filter
local tbl_map = vim.tbl_map

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local get_tabpage = api.nvim_win_get_tabpage
local get_bufn = api.nvim_win_get_buf
local win_list = api.nvim_tabpage_list_wins
local close_win = api.nvim_win_close
local list_wins = api.nvim_list_wins

local floor = math.floor

---@type OptSetterFun
local function key_opts(desc, bufn)
	bufn = (is_num(bufn) and bufn >= 0) and bufn or 0

	---@type KeyMapOpts
	local res = {
		desc = 'NvimTree: ' .. desc,
		buffer = bufn,
		noremap = true,
		silent = true,
		nowait = true,
	}

	return res
end

local Tree = require('nvim-tree')
local View = require('nvim-tree.view')
local Api = require('nvim-tree.api')

local Tapi = Api.tree
local Tnode = Api.node
local CfgApi = Api.config

---@type AnyFunc
local open = Tapi.open
---@type AnyFunc
local close = Tapi.close
---@type AnyFunc
local toggle = Tapi.toggle
---@type AnyFunc
local toggle_help = Tapi.toggle_help
---@type AnyFunc
local focus = Tapi.focus
---@type AnyFunc
local change_root = Tapi.change_root
---@type AnyFunc
local change_root_to_parent = Tapi.change_root_to_parent
---@type AnyFunc
local reload = Tapi.reload
---@type AnyFunc
local get_node = Tapi.get_node_under_cursor
---@type AnyFunc
local collapse_all = Tapi.collapse_all

---@type fun(keys: (KeyMapArr[])|KeyMapDict|(KeyMapArgs[]))
local map_lft = function(keys)
	if not is_tbl(keys) or empty(keys) then
		return
	end

	for k, args in next, keys do
		if is_num(k) and is_str(args.lhs) and (is_str(args.rhs) or is_fun(args.rhs)) then
			args.opts = is_tbl(args.opts) and args.opts or {}
			nmap(args.lhs, args.rhs, args.opts)
		elseif is_num(k) and is_str(args[1]) and (is_str(args[2]) or is_fun(args[2])) then
			args[3] = is_tbl(args[3]) and args[3] or {}
			nmap(args[1], args[2], args[3])
		elseif is_str(k) and (is_str(args[1]) or is_fun(args[1])) then
			args[2] = is_tbl(args[2]) and args[2] or {}
			nmap(k, args[1], args[2])
		elseif is_str(k) and (is_str(args.rhs) or is_fun(args.rhs)) then
			args.opts = is_tbl(args.opts) and args.opts or {}
			nmap(k, args[1], args.opts)
		else
			error('(lazy_cfg.nvim_tree.map_lft): Invalid key table.')
		end
	end
end

---@type (KeyMapArr[])|KeyMapDict|(KeyMapArgs[])
local my_maps = {
	['<leader>fto'] = {
		open,
		key_opts('Open NvimTree'),
	},
	['<leader>ftt'] = {
		toggle,
		key_opts('Toggle NvimTree'),
	},
	['<leader>ftd'] = {
		close,
		key_opts('Close NvimTree'),
	},

	['<leader>ftf'] = {
		focus,
		key_opts('Focus NvimTree'),
	},
}

map_lft(my_maps)

---@type fun(nwin: integer)
local function tab_win_close(nwin)
	local ntab = get_tabpage(nwin)
	local nbuf = get_bufn(nwin)
	local buf_info = fn.getbufinfo(nbuf)[1]

	local tab_wins = filter(function(w)
		return w - nwin
	end, win_list(ntab))
	local tab_bufs = tbl_map(get_bufn, tab_wins)

	if buf_info.name:match('.*NvimTree_%d*$') and not empty(tab_bufs) then
		close()
	elseif #tab_bufs == 1 then
		local lbuf_info = fn.getbufinfo(tab_bufs[1])[1]

		if lbuf_info.name:match('.*NvimTree_%d*$') then
			sched(function()
				if #list_wins() == 1 then
					vim.cmd('quit')
				else
					close_win(tab_wins[1], true)
				end
			end)
		end
	end
end

---@type fun(data: BufData)
local function tree_open(data)
	local nbuf = data.buf
	local name = data.file

	local buf = vim.bo[nbuf]

	local real = fn.filereadable(name) == 1
	local no_name = name == '' and buf.buftype == ''
	local dir = fn.isdirectory(name) == 1

	if not real and not no_name then
		return
	end

	local ft = buf.ft
	local noignore = {}

	if empty(noignore) or not in_tbl(noignore, ft) then
		return
	end

	---@type TreeToggleOpts
	local toggle_opts = { focus = false, find_file = true }

	---@type TreeOpenOpts
	local open_opts = { find_file = true }

	if dir then
		vim.cmd('cd ' .. name)
		open()
	else
		toggle(toggle_opts)
	end
end

local function edit_or_open()
	---@type AnyFunc
	local edit = Tnode.open.edit

	---@type TreeNode
	local node = get_node()
	local nodes = node.nodes or nil

	edit()

	if not is_nil(nodes) then
		close()
	end
end

local function vsplit_preview()
	---@type TreeNode
	local node = get_node()
	local nodes = node.nodes or nil

	---@type AnyFunc
	local edit = Tnode.open.edit
	---@type AnyFunc
	local vert = Tnode.open.vertical

	if not is_nil(nodes) then
		edit()
	else
		vert()
	end

	focus()
end

local function git_add()
	---@type TreeNode
	local node = get_node()

	local ngs = node.git_status
	local ngsf = ngs.file
	local abs = node.absolute_path
	local gs = ngsf or ''

	if empty(gs) then
		if is_tbl(ngs.dir.direct) and not empty(ngs.dir.direct) then
			gs = ngs.dir.direct[1]
		elseif is_tbl(ngs.dir.indirect) and not empty(ngs.dir.indirect) then
			gs = ngs.dir.indirect[1]
		end
	end

	---@type TreeGitConds
	local conds = {
		add = { '??', 'MM', 'AM', ' M' },
		restore = { 'M ', 'A ' },
	}

	if in_tbl(conds.add, gs) then
		fn.system('git add ' .. abs)
	elseif in_tbl(conds.restore, gs) then
		fn.system('git restore --staged ' .. abs)
	end

	reload()
end

local function swap_then_open_tab()
	---@type AnyFunc
	local tab = Tnode.open.tab

	---@type TreeNode
	local node = get_node()

	if is_tbl(node) and not empty(node) then
		vim.cmd('wincmd l')
		tab(node)
	end
end

---@type fun(bufn: integer)
local on_attach = function(bufn)
	CfgApi.mappings.default_on_attach(bufn)

	---@type (KeyMapArr[])|KeyMapDict|(KeyMapArgs[])
	local keys = {
		['<C-t>'] = {
			change_root_to_parent,
			key_opts('Set Root To Upper Dir', bufn),
		},
		['?'] = {
			toggle_help,
			key_opts('Help', bufn),
		},
		['<C-f>'] = {
			edit_or_open,
			key_opts('Edit Or Open', bufn),
		},
		['P'] = {
			vsplit_preview,
			key_opts('Vsplit Preview', bufn),
		},
		['c'] = {
			close,
			key_opts('Close', bufn),
		},
		['HA'] = {
			collapse_all,
			key_opts('Collapse All', bufn),
		},
		['ga'] = {
			git_add,
			key_opts('Git Add...', bufn),
		},
		['t'] = {
			swap_then_open_tab,
			key_opts('Open Tab', bufn),
		},
	}

	map_lft(keys)
end

local HEIGHT_RATIO = 6 / 7
local WIDTH_RATIO = 2 / 3

Tree.setup({
	on_attach = on_attach,

	sort = {
		sorter = 'name',
		folders_first = false,
		files_first = false,
	},

	auto_reload_on_write = true,

	disable_netrw = true,
	hijack_netrw = true,
	hijack_cursor = true,
	hijack_directories = {
		enable = true,
		auto_open = true,
	},

	reload_on_bufenter = true,

	view = {
		float = {
			enable = true,
			quit_on_focus_loss = true,
			open_win_config = function()
				local cols = vim.opt.columns
				local rows = vim.opt.lines
				local cmdh = vim.opt.cmdheight

				local screen_w = cols:get()
				local screen_h = rows:get() - cmdh:get()
				local window_w = screen_w * WIDTH_RATIO
				local window_h = screen_h * HEIGHT_RATIO
				local window_w_int = floor(window_w)
				local window_h_int = floor(window_h)
				local center_x = (screen_w - window_w) / 2
				local center_y = ((rows:get() - window_h) / 2) - cmdh:get()
				return {
					border = 'rounded',
					relative = 'editor',
					row = center_y,
					col = center_x,
					width = window_w_int,
					height = window_h_int,
				}
			end,
		},
		width = function()
			return floor(vim.opt.columns:get() * WIDTH_RATIO)
		end,
	},
	renderer = {
		group_empty = true,
		add_trailing = false,
		full_name = false,

		indent_width = 2,
		indent_markers = {
			enable = true,
			inline_arrows = true,
			icons = {
				corner = '└',
				edge = '│',
				item = '│',
				bottom = '─',
				none = ' ',
			},
		},

		icons = {
			web_devicons = {
				file = { enable = true, color = true },
				folder = { enable = true, color = true },
			},

			git_placement = 'signcolumn',
			modified_placement = 'before',
			diagnostics_placement = 'after',
			bookmarks_placement = 'after',

			symlink_arrow = ' ➛ ',
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
				modified = true,
				diagnostics = true,
				bookmarks = false,
			},
			glyphs = {
				default = '',
				symlink = '',
				bookmark = '󰆤',
				modified = '●',
				folder = {
					arrow_closed = '',
					arrow_open = '',
					default = '',
					open = '',
					empty = '',
					empty_open = '',
					symlink = '',
					symlink_open = '',
				},
				git = {
					unstaged = '✗',
					staged = '✓',
					unmerged = '',
					renamed = '➜',
					untracked = '★',
					deleted = '',
					ignored = '◌',
				},
			},
		},
	},
	filters = { dotfiles = false },
	live_filter = {
		prefix = '[FILTER]: ',
		always_show_folders = true,
	},
})

if exists('telescope') then
	local Fs = Api.fs
	local tree_actions = {
		{
			name = 'Create node',
			handler = Fs.create,
		},
		{
			name = 'Remove node',
			handler = Fs.remove,
		},
		{
			name = 'Trash node',
			handler = Fs.trash,
		},
		{
			name = 'Rename node',
			handler = Fs.rename,
		},
		{
			name = 'Fully rename node',
			handler = Fs.rename_sub,
		},
		{
			name = 'Copy',
			handler = Fs.copy.node,
		},

		-- ... other custom actions you may want to display in the menu
	}

	local function tree_actions_menu(node)
		local Finders = require('telescope.finders')
		local Pickers = require('telescope.pickers')
		local Sorters = require('telescope.sorters')

		local entry_maker = function(menu_item)
			return {
				value = menu_item,
				ordinal = menu_item.name,
				display = menu_item.name,
			}
		end

		local finder = Finders.new_table({
			results = tree_actions,
			entry_maker = entry_maker,
		})

		local sorter = Sorters.get_generic_fuzzy_sorter()

		local default_options = {
			finder = finder,
			sorter = sorter,
			attach_mappings = function(prompt_buffer_number)
				local actions = require('telescope.actions')

				-- On item select
				actions.select_default:replace(function()
					local state = require('telescope.actions.state')
					local selection = state.get_selected_entry()

					-- Closing the picker
					actions.close(prompt_buffer_number)
					-- Executing the callback
					selection.value.handler(node)
				end)

				-- The following actions are disabled in this example
				-- You may want to map them too depending on your needs though
				-- actions.add_selection:replace(function() end)
				-- actions.remove_selection:replace(function() end)
				-- actions.toggle_selection:replace(function() end)
				-- actions.select_all:replace(function() end)
				-- actions.drop_all:replace(function() end)
				-- actions.toggle_all:replace(function() end)

				return true
			end,
		}

		-- Opening the menu
		Pickers.new({ prompt_title = 'Tree Menu' }, default_options):find()
	end
end

-- Auto-open file after creation
--[[ Api.events.subscribe(Api.events.Event.FileCreated, function(file)
	vim.cmd('ed ' .. file.fname)
end) ]]

---@type HlDict
local hl_groups = {
	['NvimTreeExecFile'] = { fg = '#ffa0a0' },
	['NvimTreeSpecialFile'] = { fg = '#ff80ff', underline = true },
	['NvimTreeSymlink'] = { fg = 'Yellow', italic = true },
	['NvimTreeImageFile'] = { link = 'Title' },
}

---@type AuDict
local au_cmds = {
	['VimEnter'] = { callback = tree_open },
	['WinClosed'] = {
		callback = function()
			---@type integer
			local nwin = tonumber(fn.expand('<amatch>'))

			local tabc = function()
				return tab_win_close(nwin)
			end

			sched_wp(tabc)
		end,
		nested = true,
	},
	['VimResized'] = {
		group = 'NvimTreeResize',
		callback = function()
			if View.is_visible() then
				View.close()
				Tapi.open()
			end
		end,
	},
	['BufEnter'] = {
		nested = true,
		callback = function()
			local ATree = Api.tree

			local togg = ATree.toggle

			-- Only 1 window with nvim-tree left: we probably closed a file buffer
			if api.nvim_list_wins() == 1 and ATree.is_tree_buf() then
				-- Required to let the close event complete. An error is thrown without this.
				vim.defer_fn(function()
					-- close nvim-tree: will go to the last hidden buffer used before closing
					togg({ find_file = true, focus = true })
					-- re-open nivm-tree
					togg({ find_file = true, focus = true })
					-- nvim-tree is still the active window. Go to the previous window.
					vim.cmd('wincmd p')
				end, 0)
			end
		end,
	},
}

augroup('NvimTreeResize', {
	clear = true,
})
for k, v in next, au_cmds do
	if is_str(k) and is_tbl(v) then
		au(k, v)
	end
end

for k, v in next, hl_groups do
	if is_str(k) and is_tbl(v) and not empty(v) then
		hi(k, v)
	end
end
