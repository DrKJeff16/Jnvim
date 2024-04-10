---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local pfx = ''

local User = require('user')
local exists = User.exists
local types = User.types.colorschemes

---@type CscSubMod
local M = {
	mod_pfx = 'lazy_cfg.colorschemes.catppuccin',
	mod_cmd = 'colorscheme catppuccin',
}

if exists('catppuccin') then
	function M.setup()
		local Cppc = require('catppuccin')

		Cppc.setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
    		-- flavour = "auto" -- will respect terminal's background
    		background = { -- :h background
        		light = "latte",
        		dark = "macchiato",
    		},
    		transparent_background = false, -- disables setting the background color.
    		show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
    		term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
    		dim_inactive = {
        		enabled = false, -- dims the background color of inactive window
        		shade = "dark",
        		percentage = 0.10, -- percentage of the shade to apply to the inactive window
    		},
    		no_italic = false, -- Force no italic
    		no_bold = false, -- Force no bold
    		no_underline = false, -- Force no underline
    		styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        		comments = {}, -- Change the style of comments
        		conditionals = { "bold" },
        		loops = { 'bold' },
        		functions = { 'bold' },
        		keywords = { 'bold' },
        		strings = {},
        		variables = {},
        		numbers = {},
        		booleans = { 'bold' },
        		properties = {},
        		types = {},
        		operators = {},
        		-- miscs = {}, -- Uncomment to turn off hard-coded styles
    		},
    		color_overrides = {},
    		custom_highlights = {},
    		default_integrations = true,
    		integrations = {
        		cmp = true,
        		gitsigns = true,
        		nvimtree = true,
        		treesitter = true,
        		notify = true,
        		mini = {
            		enabled = true,
            		indentscope_color = "",
        		},
        		-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    		},
		})

		vim.cmd(M.mod_cmd)
	end
end

return M
