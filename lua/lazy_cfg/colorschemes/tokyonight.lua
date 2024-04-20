---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local pfx = ''

local User = require('user')
local exists = User.check.exists.module
local types = User.types.colorschemes

local M = {
	mod_pfx = 'lazy_cfg.colorschemes.tokyonight',
	mod_cmd = 'colorscheme tokyonight',
}

if exists('tokyonight') then
	function M.setup()
		local Tokyonight = require('tokyonight')

		Tokyonight.setup({
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

			style = 'night',
		live_reload = true,
		use_background = true,
		hide_inactive_statusline = false,
		lualine_bold = true,
		})

		vim.cmd(M.mod_cmd)
	end
end

return M
