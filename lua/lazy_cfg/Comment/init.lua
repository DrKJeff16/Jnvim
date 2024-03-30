---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types')
require('user.types.user.maps')
local User = require('user')
local exists = User.exists

if not exists('Comment') then
	return
end

local bo = vim.bo
local set = vim.o
local fn = vim.fn
local api = vim.api
local let = vim.g
local keymap = vim.keymap

local kmap = keymap.set
local map = api.nvim_set_keymap

---@param lhs string
---@param rhs string|fun(...): any
---@param opts KeyMapOpts
local nmap_k = function(lhs, rhs, opts)
	opts = opts or {}

	opts.noremap = opts.noremap or true
	opts.nowait = opts.nowait or true
	opts.silent = opts.silent or true

	kmap('n', lhs, rhs, opts)
end
---@param lhs string
---@param rhs string
---@param opts ApiMapOpts
local nmap = function(lhs, rhs, opts)
	opts = opts or {}

	opts.noremap = opts.noremap or true
	opts.nowait = opts.nowait or true
	opts.silent = opts.silent or true

	map('n', lhs, rhs, opts)
end

local Comment = require('Comment')

Comment.setup({
	---Function to call before (un)comment
	---@return string
	pre_hook = function(c)
		return bo.commentstring
	end,
	---Add a space b/w comment and the line
	padding = true,
	---Whether the cursor should stay at its position
	sticky = true,
	---Lines to be ignored while (un)comment
	ignore = nil,
	---LHS of toggle mappings in NORMAL mode
	toggler = {
		---Line-comment toggle keymap
		line = 'gcc',
		---Block-comment toggle keymap
		block = 'gbc',
	},
	---LHS of operator-pending mappings in NORMAL and VISUAL mode
	opleader = {
		---Line-comment keymap
		line = 'gc',
		---Block-comment keymap
		block = 'gb',
	},
	---LHS of extra mappings
	extra = {
		---Add comment on the line above
		above = 'gcO',
		---Add comment on the line below
		below = 'gco',
		---Add comment at the end of line
		eol = 'gcA',
	},
	---Enable keybindings
	---NOTE: If given `false` then the plugin won't create any mappings
	mappings = {
		---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
		basic = true,
		---Extra mapping; `gco`, `gcO`, `gcA`
		extra = true,
	},
	---Function to call after (un)comment
	post_hook = nil,
})
