---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_m = User.types.colorschemes

local exists = Check.exists.module
local vim_exists = Check.exists.vim_exists

local M = {
	mod_pfx = 'lazy_cfg.colorschemes.tokyonight',
	mod_cmd = 'colorscheme tokyonight',
}

if exists('tokyonight') then
	function M.setup()
		local TN = require('tokyonight')

		---@type Config
		local opts = {
			terminal_colors = vim_exists('+termguicolors'),
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
		}

		TN.setup(opts)

		vim.cmd(M.mod_cmd)
	end
end

return M
