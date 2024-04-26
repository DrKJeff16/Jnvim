---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local kmap = User.maps.kmap
local hl = User.highlight

local nmap = kmap.n
local hi = hl.hl
local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str

if not exists('nvim-tree') then
	return
end

local types = User.types.nvim_tree

local api = vim.api
local fn = vim.fn
local let = vim.g
local set = vim.o
local opt = vim.opt
local bo = vim.bo

local sched = vim.schedule
local sched_wp = vim.schedule_wrap
local in_tbl = vim.tbl_contains
local empty = vim.tbl_isempty
local filter_tbl = vim.tbl_filter
local tbl_map = vim.tbl_map

local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local get_tabpage = api.nvim_win_get_tabpage
local get_bufn = api.nvim_win_get_buf
local win_list = api.nvim_tabpage_list_wins
local close_win = api.nvim_win_close
local list_wins = api.nvim_list_wins

---@type OptSetterFun
local function key_opts(desc, bufn)
	bufn = bufn or 0
	bufn = (bufn > 0 and bufn or 0)

	---@type KeyMapOpts
	local res = {
		desc = 'NvimTree: '..desc,
		buffer = bufn,
		noremap = true,
		silent = true,
		nowait = true,
	}

	return res
end

local Tree = require('nvim-tree')
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

---@param keys KeyMapArgs[]
local map_lft = function(keys)
	if is_tbl(keys) or empty(keys) then
		return
	end

	for _, args in next, keys do
		if not is_nil(args.lhs) and not is_nil(args.rhs) then
			nmap(args.lhs, args.rhs, args.opts or {})
		end
	end
end

---@type KeyMapArgs[]
local my_maps = {
	{
		lhs = '<Leader>fto',
		rhs = open,
		opts = key_opts('Open NvimTree'),
	},
	{
		lhs = '<Leader>ftt',
		rhs = toggle,
		opts = key_opts('Toggle NvimTree'),
	},
	{
		lhs = '<Leader>ftd',
		rhs = close,
		opts = key_opts('Close NvimTree'),
	},
	{
		lhs = '<Leader>ftf',
		rhs = focus,
		opts = key_opts('Focus NvimTree'),
	},
}

map_lft(my_maps)

---@param nwin number
local tab_win_close = function(nwin)
	local ntab = get_tabpage(nwin)
	local nbuf = get_bufn(nwin)
	local buf_info = fn.getbufinfo(nbuf)[1]

	local tab_wins = filter_tbl(function(w) return w - nwin end, win_list(ntab))
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

---@param data BufData
local tree_open = function(data)
	local cmd = vim.cmd

	local cd = cmd.cd
	local enew = cmd.enew
	local bw = cmd.bw

	local nbuf = data.buf
	local name = data.file

	local real = fn.filereadable(name) == 1
	local no_name = name == '' and bo[nbuf].buftype == ''
	local dir = fn.isdirectory(name) == 1

	if not real and not no_name then
		return
	end

	local ft = bo[nbuf].ft
	local noignore = {
		'codeowners',
		'gitignore',
	}

	if not in_tbl(noignore, ft) then
		return
	end

	---@type TreeToggleOpts
	local toggle_opts = { focus = false, find_file = true }

	---@type TreeOpenOpts
	local open_opts = { find_file = true }

	if dir then
		cd(name)
		open()
	else
		toggle(toggle_opts)
	end
end

local edit_or_open = function()
	---@type TreeNode
	local node = get_node()
	local nodes = node.nodes or nil

	local edit = Tnode.open.edit

	edit()

	if not is_nil(nodes) then
		close()
	end
end

local vsplit_preview = function()
	---@type TreeNode
	local node = get_node()
	local nodes = node.nodes or nil

	local edit = Tnode.open.edit
	local vert = Tnode.open.vertical

	if not is_nil(nodes) then
		edit()
	else
		vert()
	end

	focus()
end

local git_add = function()
	---@type TreeNode
	local node = get_node()

	local ngs = node.git_status
	local ngsf = ngs.file
	local abs = node.absolute_path
	local gs = ngsf or ''

	if gs == '' then
		if not is_nil(ngs.dir.direct) then
			gs = ngs.dir.direct[1]
		elseif not is_nil(ngs.dir.indirect) then
			gs = ngs.dir.indirect[1]
		end
	end

	---@type TreeGitConds
	local conds = {
		add = { '??', 'MM', 'AM', ' M' },
		restore = { 'M ', 'A ' },
	}

	if in_tbl(conds.add, gs) then
		vim.cmd('silent !git add'..abs)
	elseif in_tbl(conds.restore, gs) then
		vim.cmd('silent !git restore --staged'..abs)
	end

	reload()
end

local swap_then_open_tab = function()
	local cmd = vim.cmd

	local tab = Tnode.open.tab

	---@type TreeNode
	local node = get_node()

	cmd('wincmd l')
	tab(node)
end

---@param bufn integer
local on_attach = function(bufn)
	CfgApi.mappings.default_on_attach(bufn)

	---@type KeyMapArgs[]
	local keys = {
		{
			lhs = '<C-t>',
			rhs = change_root_to_parent,
			opts = key_opts('Set Root To Upper Dir', bufn),
		},
		{
			lhs = '?',
			rhs = toggle_help,
			opts = key_opts('Help', bufn),
		},
		{
			lhs = '<C-f>',
			rhs = edit_or_open,
			opts = key_opts('Edit Or Open', bufn),
		},
		{
			lhs = 'P',
			rhs = vsplit_preview,
			opts = key_opts('Vsplit Preview', bufn),
		},
		{
			lhs = 'c',
			rhs = close,
			opts = key_opts('Close', bufn),
		},
		{
			lhs = 'HA',
			rhs = collapse_all,
			opts = key_opts('Collapse All', bufn),
		},
		{
			lhs = 'ga',
			rhs = git_add,
			opts = key_opts('Git Add...', bufn),
		},
		{
			lhs = 't',
			rhs = swap_then_open_tab,
			opts = key_opts('Open Tab', bufn),
		},
	}

	map_lft(keys)
end

Tree.setup({
	on_attach = on_attach,

	sort = { sorter = 'case_sensitive' },
	view = { width = 15 },
	renderer = { group_empty = true },
	filters = { dotfiles = false },

	-- NOTE: Useful for `project.nvim`.
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_focused_file = {
		enable = true,
		update_root = true,
	},
})

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
			---@type number
			local nwin = tonumber(fn.expand('<amatch>'))

			local tabc = function()
				return tab_win_close(nwin)
			end
			sched_wp(tabc)
		end,
		nested = true,
	},
}

for k, v in next, au_cmds do
	if is_str(k) and is_tbl(v) then
		au(k, v)
	end
end

for k, v in next, hl_groups do
	if is_str(k) and is_tbl(v) then
		hi(k, v)
	end
end
