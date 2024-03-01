---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('cmp') then
	return
end

local insp = vim.inspect

local Cmp = require('cmp')
local cmp_ap = require('nvim-autopairs.completion.cmp')
local handlers = require('nvim-autopairs.completion.handlers')

local ft_handles = {
	filetypes = {
		-- "*" is a alias to all filetypes
		["*"] = {
			["("] = {
			    kind = {
			        Cmp.lsp.CompletionItemKind.Function,
			        Cmp.lsp.CompletionItemKind.Method,
			    },
			    handler = handlers["*"]
			}
		},
		lua = {
			["("] = {
			    kind = {
			        Cmp.lsp.CompletionItemKind.Function,
			        Cmp.lsp.CompletionItemKind.Method
			    },
			},
		},
		tex = false,
		markdown = false,
	}
}

local M = {
	on = function()
		Cmp.event:on(
			'confirm_done',
			cmp_ap.on_confirm_done(ft_handles)
		)
	end
}

return M
