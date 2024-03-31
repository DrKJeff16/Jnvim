---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local pfx = 'lazy_cfg.colorschemes.'

require('user.types.colorschemes')
local User = require('user')
local exists = User.exists

local fn = vim.fn

---@type CscSubMod
local M = {}

if exists('nightfox') then
	M.mod_pfx = pfx..'nightfox'
	M.mod_cmd = 'carbonfox'

	function M.setup()
		local Nf = require('nightfox')

		Nf.setup({
			options = {
				-- Compiled file's destination location
				compile_path = fn.stdpath("cache") .. "/nightfox",
				compile_file_suffix = "_compiled", -- Compiled file suffix
				transparent = false,     -- Disable setting background
				terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
				dim_inactive = false,    -- Non focused panes set to alternative background
				module_default = true,   -- Default enable value for modules
				colorblind = {
					enable = false,        -- Enable colorblind support
					simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
					severity = {
						protan = 0,          -- Severity [0,1] for protan (red)
						deutan = 0,          -- Severity [0,1] for deutan (green)
						tritan = 0,          -- Severity [0,1] for tritan (blue)
					},
				},
				styles = {               -- Style to be applied to different syntax groups
					comments = "NONE",     -- Value is any valid attr-list value `:help attr-list`
					conditionals = "NONE",
					constants = "bold",
					functions = "NONE",
					keywords = "bold",
					numbers = "NONE",
					operators = "NONE",
					strings = "NONE",
					types = "bold",
					variables = "NONE",
				},
				inverse = {             -- Inverse highlight for different types
					match_paren = false,
					visual = false,
					search = false,
				},
				modules = {             -- List of various plugins and additional options
					-- ...
				},
			},
			palettes = {},
			specs = {},
			groups = {},
		})

		vim.cmd('colorscheme '..M.mod_cmd)
	end
end

return M
