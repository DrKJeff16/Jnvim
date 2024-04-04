---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local pfx = 'lazy_cfg.colorschemes.'

require('user.types')
require('user.types.colorschemes')
local User = require('user')
local exists = User.exists

local M = {
	mod_pfx = pfx..'tokyonight',
	mod_cmd = 'colorscheme tokyonight',
}

if exists('tokyonight') then
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

		vim.cmd(M.mod_cmd)
	end
end

return M
