---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local maps_t = User.types.user.maps
local kmap = User.maps.kmap

local exists = Check.exists.module
local nmap = kmap.n

if not exists('hover') then
	return
end

local Hover = require('hover')

Hover.setup({
	init = function()
		-- Providers
		require('hover.providers.lsp')
		require('hover.providers.man')

		--- Github
		-- require('hover.providers.gh')

		--- Github: Users
		-- require('hover.providers.gh_user')

		--- Jira
		-- require('hover.providers.jira')

		--- DAP
		-- require('hover.providers.dap')

		--- Dictionary
		-- require('hover.providers.dictionary')
	end,
	preview_opts = { border = 'single' },
	preview_window = false,
	title = true,
	mouse_providers = { 'LSP' },
	mouse_delay = 1000,
})

---@type KeyMapDict
local Keys = {
	['K'] = { Hover.hover, { desc = 'Hover' } },
	['gK'] = { Hover.hover_select, { desc = 'Hover Select' } },
	['<C-p>'] = {
		function()
			Hover.hover_switch('previous')
		end,
		{ desc = 'Previous Hover' }
	},
	['<C-n>'] = {
		function()
			Hover.hover_switch('next')
		end,
		{ desc = 'Next Hover' }
	},
}

for lhs, v in next, Keys do
	nmap(lhs, v[1], v[2] or {})
end
