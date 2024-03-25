---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('nvim-tree') then
	return
end

local pfx = 'lazy_cfg.tree.'

local api = vim.api
local fn = vim.fn
local let = vim.g
local set = vim.o
local opt = vim.opt
local bo = vim.bo
local sched = vim.schedule
local sched_wp = vim.schedule_wrap

opt.termguicolors = true

let.loaded_netrw = 1
let.loaded_netrwPlugin = 1

local kmap = vim.keymap.set
local map = api.nvim_set_keymap
local au = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local hi = api.nvim_set_hl

local Tree = require('nvim-tree')
local Api = require('nvim-tree.api')

local Tapi = require('nvim-tree.api').tree

---@alias KeyOpts vim.keymap.set.Opts

---@param lhs string
---@param rhs string|fun()
---@param kopts KeyOpts
local tree_map = function(lhs, rhs, kopts)
	kmap('n', lhs, rhs, kopts)
end

kmap('n', '<Leader>ftt', Tapi.open, { noremap = true, silent = true })
kmap('n', '<Leader>ftd', Tapi.close, { noremap = true, silent = true })
kmap('n', '<Leader>ftf', Tapi.focus, { noremap = true, silent = true })

---@param nwin number
local tab_win_close = function(nwin)
	local get_tabpage = api.nvim_win_get_tabpage
	local get_bufn = api.nvim_win_get_buf
	local win_list = api.nvim_tabpage_list_wins
	local close_win = api.nvim_win_close
	local list_wins = api.nvim_list_wins

	local ntab = get_tabpage(nwin)
	local nbuf = get_bufn(nwin)
	local buf_info = fn.getbufinfo(nbuf)[1]

	local tab_wins = vim.tbl_filter(function(w) return w - nwin end, win_list(ntab))
	local tab_bufs = vim.tbl_map(get_bufn, tab_wins)

	if buf_info.name:match('.*NvimTree_%d*$') then
		if not vim.tbl_isempty(tab_bufs) then
			Tapi.close()
		end
	elseif #tab_bufs == 1 then
		local lbuf_info = fn.getbufinfo(tab_bufs[1])[1]
		if lbuf_info .name:match('.*NvimTree_%d*$') then
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
	local ignore = {
		'sh',
		'bash',
		'c',
		'cpp',
		'gitignore',
		'python',
	}

	if not vim.tbl_contains(ignore, ft) then
		return
	end

	local open = Tapi.open
	local toggle = Tapi.toggle
	local focus = Tapi.focus
	local change_root = Tapi.change_root

	---@class TreeToggleOpts
	---@field focus? boolean Defaults to `true`
	---@field find_file? boolean Defaults to `false`
	---@field path? string|nil Defaults to `nil`
	---@field current_window? boolean Defaults to `false`
	---@field update_root? boolean Defaults to `false`
	local toggle_opts = {
		focus = false,
		find_file = true,
	}

	---@class TreeOpenOpts
	---@field find_file? boolean Defaults to `false`
	---@field path? string|nil Defaults to `nil`
	---@field current_window? boolean Defaults to `false`
	---@field update_root? boolean Defaults to `false`
	local open_opts = {
		find_file = true,
	}

	if dir then
		cd(data.file)
		Tapi.open()
	else
		Tapi.toggle(toggle_opts)
	end
end

local edit_or_open = function()
	local node = Tapi.get_node_under_cursor()
	local edit = Api.node.open.edit
	local close = Tapi.close

	edit()
	if not node.nodes then
		close()
	end
end

local vsplit_preview = function()
	local node = Tapi.get_node_under_cursor()
	local edit = Api.node.open.edit
	local vert = Api.node.open.vertical

	if node.nodes then
		edit()
	else
		vert()
	end

	Tapi.focus()
end

local git_add = function()
	local node = Tapi.get_node_under_cursor()
	local ngs = node.git_status
	local abs = node.absolute_path

	local gs = ngs.file

	if gs == nil then
		if ngs.dir.direct ~= nil then
			gs = ngs.dir.direct[1]
		elseif ngs.dir.indirect ~= nil then
			gs = ngs.dir.indirect[1]
		end
	end

	---@alias StrArr string[]
	---@type StrArr[]
	local conds = {
		{ '??', 'MM', 'AM', ' M' },
		{ 'M ', 'A ' },
	}

	if vim.tbl_contains(gs, conds[1]) then
		vim.cmd('silent !git add'..abs)
	elseif vim.tbl_contains(gs, conds[2]) then
		vim.cmd('silent !git restore --staged'..abs)
	end

	Tapi.reload()
end

local swap_then_open_tab = function()
	local node = Tapi.get_node_under_cursor()
	vim.cmd('wincmd l')
	Api.node.open.tab(node)
end

---@param bufn number
local on_attach = function(bufn)
	---@param desc string
	---@return KeyOpts
	local opts = function(desc)
		---@type KeyOpts
		local res = {
			desc = 'nvim tree: '..desc,
			buffer = bufn,
			noremap = true,
			silent = true,
			nowait = true,
		}

		return res
	end

	Api.config.mappings.default_on_attach(bufn)

	tree_map('<C-t>', Tapi.change_root_to_parent, opts('Up'))
	tree_map('?', Tapi.toggle_help, opts('Help'))
	tree_map("l", edit_or_open,          opts("Edit Or Open"))
	tree_map("L", vsplit_preview,        opts("Vsplit Preview"))
	tree_map("h", Tapi.close,        opts("Close"))
	tree_map("H", Tapi.collapse_all, opts("Collapse All"))
	tree_map("ga", git_add, opts("Git Add"))
	tree_map('t', swap_then_open_tab, opts('Open Tab'))
end

Tree.setup({
	on_attach = on_attach,

	sort = { sorter = 'case_sensitive' },
	view = { width = 24 },
	renderer = { group_empty = true },
	filters = { dotfiles = false },
})

---@class HlGroups
---@field name string 
---@field opts vim.api.keyset.highlight

---@type HlGroups[]
local hl_groups = {
	{ name = 'NvimTreeExecFile', opts = { fg = '#ffa0a0' } },
	{ name = 'NvimTreeSpecialFile', opts ={ fg = '#ff80ff', underline = true } },
	{ name = 'NvimTreeSymlink', opts ={ fg = 'Yellow', italic = true } },
	{ name = 'NvimTreeImageFile', opts ={ link = 'Title' } },
}

---@class AuCmds
---@field event string|string[]
---@field opts vim.api.keyset.create_autocmd

---@type AuCmds[]
local au_cmds = {
	{ event = 'VimEnter', opts = { callback = tree_open } },
	{
		event = 'WinClosed',
		opts = {
			callback = function()
				local nwin = tonumber(fn.expand('<amatch>'))
				sched_wp(tab_win_close(nwin))
			end,
			nested = true,
		}
	},
}

for _, v in next, au_cmds do
	au(v.event, v.opts)
end

---@param hls HlGroups[]
local hl_set = function(hls)
	for _, v in next, hls do
		hi(0, v.name, v.opts)
	end
end

hl_set(hl_groups)
