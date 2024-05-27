---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module

---@type CscSubMod
local M = {
	mod_pfx = 'lazy_cfg.colorschemes.catppuccin',
	mod_cmd = 'colorscheme catppuccin',
}

if exists('catppuccin') then
	function M.setup()
		local Cppc = require('catppuccin')

		---@type CatppuccinOptions
		local opts = {
			flavour = 'frappe', -- latte, frappe, macchiato, mocha
			-- flavour = "auto" -- will respect terminal's background
			background = { -- :h background
				light = 'latte',
				dark = 'mocha',
			},
			transparent_background = false, -- disables setting the background color.
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = true, -- dims the background color of inactive window
				shade = 'dark',
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			no_underline = false, -- Force no underline
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { 'altfont' }, -- Change the style of comments
				conditionals = { 'bold' },
				loops = { 'bold' },
				functions = { 'bold' },
				keywords = { 'bold' },
				strings = { 'italic' },
				variables = { 'altfont' },
				numbers = { 'altfont' },
				booleans = { 'altfont' },
				properties = { 'altfont' },
				types = { 'undercurl' },
				operators = { 'altfont' },
				-- miscs = {}, -- Uncomment to turn off hard-coded styles
			},

			--[[ color_overrides = {},
			custom_highlights = {}, ]]

			default_integrations = true,
			integrations = {
				barbar = exists('barbar'),
				cmp = exists('cmp'),
				dashboard = exists('dashboard'),
				diffview = exists('diffview'),
				gitsigns = exists('gitsigns'),
				indent_blankline = {
					enabled = exists('ibl'),
					scope_color = 'teal',
					colored_indent_levels = true,
				},
				lsp_trouble = exists('trouble'),
				markdown = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { 'bold', 'undercurl' },
						warnings = { 'underline' },
						hints = { 'italic' },
						information = { 'altfont', 'underline' },
						ok = { 'bold' },
					},
					underlines = {
						errors = { 'underline' },
						hints = { 'underline' },
						warnings = { 'underline' },
						information = { 'underline' },
						ok = { 'underline' },
					},
					inlay_hints = {
						background = true,
					},
				},
				noice = exists('noice'),
				notify = exists('notify'),
				nvimtree = exists('nvim-tree'),
				rainbow_delimiters = exists('rainbow-delimiters'),
				telescope = {
					enabled = exists('telescope'),
					-- style = 'nvchad',
				},
				treesitter = exists('nvim-treesitter'),
				treesitter_context = exists('treesitter-context'),
				which_key = exists('which-key'),
				mini = {
					enabled = true,
					indentscope_color = 'lavender',
				},
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		}

		Cppc.setup(opts)

		vim.cmd(M.mod_cmd)
	end
end

return M
