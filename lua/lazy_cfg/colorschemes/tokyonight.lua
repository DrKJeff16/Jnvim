---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_m = User.types.colorschemes

local exists = Check.exists.module

local M = {
	mod_pfx = 'lazy_cfg.colorschemes.tokyonight',
	mod_cmd = 'colorscheme tokyonight',
}

if exists('tokyonight') then
	function M.setup()
		local TN = require('tokyonight')

		---@type Config
		local opts = {
			on_colors = function(colors)
				colors.error = '#df4f4f'
			end,
			on_highlights = function(hl, c)
				local prompt = '#2d3149'
				hl.TelescopeNormal = {
					bg = c.bg_dark,
					fg = c.fg_dark
				}
				hl.TelescopeBorder = {
					bg = c.bg_dark,
					fg = c.bg_dark,
				}
				hl.TelescopePromptNormal = {
					bg = prompt,
				}
				hl.TelescopePromptBorder = {
					bg = prompt,
					fg = prompt,
				}
				hl.TelescopePromptTitle = {
					bg = prompt,
					fg = prompt,
				}
				hl.TelescopePreviewTitle = {
					bg = c.bg_dark,
					fg = c.bg_dark,
				}
				hl.TelescopeResultsTitle = {
					bg = c.bg_dark,
					fg = c.bg_dark,
				}
			end,
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
				'vista_kind',
			},

			style = 'night',
			live_reload = true,
			use_background = true,
			hide_inactive_statusline = false,
			lualine_bold = true,
			styles = {
				comments = { italic = false },
				keywords = { italic = false, bold = true },
				functions = { bold = true, italic = false },
				variables = {},
				sidebars = 'dark',
				floats = 'transparent',
			},
		}

		TN.setup(opts)

		vim.cmd(M.mod_cmd)
	end
end

return M
