---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local map = User.maps.map
local kmap = User.maps.kmap

local exists = Check.exists.module

if not exists('Comment') then
	return
end

local Comment = require('Comment')

local pre_hook = function(ctx)
	return vim.bo.commentstring
end

if exists('ts_context_commentstring') then
	pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
end

---@type CommentConfig
local opts = {
	---Function to call before (un)comment
	---@return string
	pre_hook = pre_hook,

	post_hook = function(ctx)
		local r = unpack(vim.api.nvim_win_get_cursor(0))
		local rcnt = vim.api.nvim_buf_line_count(0)
		if rcnt > r then
			vim.api.nvim_win_set_cursor(0, { r + 1, 0 })
		end
	end,
	---Add a space b/w comment and the line
	padding = true,
	---Whether the cursor should stay at its position
	sticky = true,
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
}

Comment.setup(opts)
