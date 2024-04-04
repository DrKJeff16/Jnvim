---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')
require('user.types.user.highlight')
require('user.types.user.autocmd')

local User = require('user')
local exists = User.exists
local kmap = User.maps().kmap
local hl = User.highlight()

local nmap = kmap.n

if not exists('nvim-tree') then
	return
end

local hi = hl.hl

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
-- local hi = api.nvim_set_hl
local get_tabpage = api.nvim_win_get_tabpage
local get_bufn = api.nvim_win_get_buf
local win_list = api.nvim_tabpage_list_wins
local close_win = api.nvim_win_close
local list_wins = api.nvim_list_wins

local Tree = require('nvim-tree')
local Api = require('nvim-tree.api')
local Tapi = Api.tree
local Tnode = Api.node
local CfgApi = Api.config

---@type fun(...): any
local open = Tapi.open
---@type fun(...): any
local close = Tapi.close
---@type fun(...): any
local toggle = Tapi.toggle
---@type fun(...): any
local toggle_help = Tapi.toggle_help
---@type fun(...): any
local focus = Tapi.focus
---@type fun(...): any
local change_root = Tapi.change_root
---@type fun(...): any
local change_root_to_parent = Tapi.change_root_to_parent
---@type fun(...): any
local reload = Tapi.reload
---@type fun(...): any
local get_node = Tapi.get_node_under_cursor
---@type fun(...): any
local collapse_all = Tapi.collapse_all

---@class TreeCustomKeys
---@field lhs string
---@field rhs string|fun(...): any
---@field opts? KeyMapOpts

---@param keys TreeCustomKeys[]
local map_lft = function(keys)
	if not keys or type(keys) ~= 'table' or empty(keys) then
		return
	end

	for _, args in next, keys do
		if args and type(args) == 'table' and not empty(args) then
			args.opts = args.opts or {}

			for _, v in next, { 'noremap', 'nowait', 'silent' } do
				if not args.opts[v] then
					args.opts[v] = true
				end
			end

			nmap(args.lhs, args.rhs, args.opts)
		end
	end
end

---@type TreeCustomKeys[]
local my_maps = {
	{ lhs = '<Leader>fto', rhs = open },
	{ lhs = '<Leader>ftt', rhs = toggle },
	{ lhs = '<Leader>ftd', rhs = close },
	{ lhs = '<Leader>ftc', rhs = close },
	{ lhs = '<Leader>ftf', rhs = focus },
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

---@class BufData
---@field file string
---@field buf number

---@param data BufData
local tree_open = function(data)
	local cmd = vim.cmd

	local cd = cmd.cd
	local enew = cmd.enew
	local bw = cmd.bw

	local real = fn.filereadable(data.file) == 1
	local no_name = data.file == '' and bo[data.buf].buftype == ''
	local dir = fn.isdirectory(data.file) == 1
	if not real and not no_name then
		return
	end

	local ft = bo[data.buf].ft
	local noignore = {
		'sh',
		'bash',
		'c',
		'cpp',
		'gitignore',
		'python',
	}

	if not in_tbl(noignore, ft) then
		return
	end

	---@class TreeToggleOpts
	---@field focus? boolean Defaults to `true`
	---@field find_file? boolean Defaults to `false`
	---@field path? string|nil Defaults to `nil`
	---@field current_window? boolean Defaults to `false`
	---@field update_root? boolean Defaults to `false`
	local toggle_opts = { focus = false, find_file = true }

	---@class TreeOpenOpts
	---@field find_file? boolean Defaults to `false`
	---@field path? string|nil Defaults to `nil`
	---@field current_window? boolean Defaults to `false`
	---@field update_root? boolean Defaults to `false`
	local open_opts = { find_file = true }

	if dir then
		cd(data.file)
		open()
	else
		toggle(toggle_opts)
	end
end

local edit_or_open = function()
	local node = get_node()
	local edit = Tnode.open.edit

	edit()
	if not node.nodes then
		close()
	end
end

local vsplit_preview = function()
	local node = get_node()
	local edit = Tnode.open.edit
	local vert = Tnode.open.vertical

	if node.nodes then
		edit()
	else
		vert()
	end

	focus()
end

local git_add = function()
	---@class TreeNodeGSDir
	---@field direct? string[]
	---@field indirect? string[]

	---@class TreeNodeGitStatus
	---@field file? string
	---@field dir TreeNodeGSDir

	---@class TreeNode
	---@field git_status TreeNodeGitStatus
	---@field absolute_path string
	---@field file string
	local node = get_node()
	local ngs = node.git_status
	local ngsf = ngs.file
	local abs = node.absolute_path
	local gs = ngsf or ''

	if gs == '' then
		if ngs.dir.direct ~= nil then
			gs = ngs.dir.direct[1]
		elseif ngs.dir.indirect ~= nil then
			gs = ngs.dir.indirect[1]
		end
	end

	---@class StrArr
	---@field add string[]
	---@field restore string[]
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
	local node = get_node()
	vim.cmd('wincmd l')
	Tnode.open.tab(node)
end

---@param bufn integer
local on_attach = function(bufn)
	---@param desc string
	---@return KeyMapOpts
	local opts = function(desc)
		---@type KeyMapOpts
		local res = {
			desc = 'nvim tree: '..desc,
			buffer = bufn,
			noremap = true,
			silent = true,
			nowait = true,
		}

		return res
	end

	CfgApi.mappings.default_on_attach(bufn)

	nmap('<C-t>', change_root_to_parent, opts('Up'))
	nmap('?', toggle_help, opts('Help'))
	nmap('l', edit_or_open,          opts('Edit Or Open'))
	nmap('L', vsplit_preview,        opts('Vsplit Preview'))
	nmap('h', close,        opts('Close'))
	nmap('H', collapse_all, opts('Collapse All'))
	nmap('ga', git_add, opts('Git Add'))
	nmap('t', swap_then_open_tab, opts('Open Tab'))
end

Tree.setup({
	on_attach = on_attach,

	sort = { sorter = 'case_sensitive' },
	view = { width = 24 },
	renderer = { group_empty = true },
	filters = { dotfiles = false },
})

---@type HlPair[]
local hl_groups = {
	{ name = 'NvimTreeExecFile', opts = { fg = '#ffa0a0' } },
	{ name = 'NvimTreeSpecialFile', opts = { fg = '#ff80ff', underline = true } },
	{ name = 'NvimTreeSymlink', opts = { fg = 'Yellow', italic = true } },
	{ name = 'NvimTreeImageFile', opts = { link = 'Title' } },
}

---@type AuPair[]
local au_cmds = {
	{ event = 'VimEnter', opts = { callback = tree_open } },
	{
		event = 'WinClosed',
		opts = {
			callback = function()
				---@type number
				local nwin = tonumber(fn.expand('<amatch>'))

				local tabc = function()
					return tab_win_close(nwin)
				end
				sched_wp(tabc)
			end,
			nested = true,
		}
	},
}

for _, v in next, au_cmds do
	if v.event and v.opts then
		au(v.event, v.opts)
	end
end

for _, v in next, hl_groups do
	hi(v.name, v.opts)
end
