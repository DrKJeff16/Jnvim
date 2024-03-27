---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local pfx = 'lazy_cfg.colorschemes.'

require('user.types')
require(pfx..'types')
local User = require('user')
local exists = User.exists

---@type CscSubMod|nil
local M = nil

if exists('tokyonight') then
	M = {
		mod_pfx = pfx..'tokyonight',
		mod_cmd = 'tokyonight-night',
	}

	function M.setup()
		local Tokyonight = require('tokyonight')

		Tokyonight.setup({
			theme = 'night',
			terminal_colors = true,
			transparent = false,
			sidebars = {
				'qf',
				'help',
				'lazy',
				'checkhealth',
				'terminal',
				'packer',
				'TelescopePrompt',
			},
		})

		vim.cmd('colorscheme '..M.mod_cmd)
	end
end

return M
