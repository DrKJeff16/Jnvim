---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('cmp') then
	return
end

local insp = vim.inspect

local cmp = require('cmp')
local cmp_ap = require('nvim-autopairs.completion.cmp')
local handlers = require('nvim-autopairs.completion.handlers')

local cmp_lsp = cmp.lsp

local ft_handles = {
	filetypes = {
		-- "*" is a alias to all filetypes
		["*"] = {
			["("] = {
				kind = {
					cmp_lsp.CompletionItemKind.Function,
					cmp_lsp.CompletionItemKind.Method,
				},
				handler = handlers["*"],
			},
		},
		lua = false,
		tex = false,
		markdown = false,
	}
}

---@class APCmp
---@field on fun()
local M = {
	on = function()
		cmp.event:on(
		'confirm_done',
		cmp_ap.on_confirm_done(ft_handles)
		)
	end,
}

return M
