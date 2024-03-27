---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('bufferline') then
	return
end

local pfx = 'lazy_cfg.lualine.'

local BLine = require('bufferline')

---@param count integer
---@param level 'error'|'warning'
---@param diagnostics_dict? table<string, any>
---@param context? table
---@return string
local diagnostics_indicator = function(count, level, diagnostics_dict, context)
	local icon = level:match("error") and " " or " "
	return " " .. icon .. count
end

BLine.setup({
	options = {
		mode = 'buffers',

		style_preset = BLine.style_preset.default,
		themable = true,

		numbers = 'buffer_id',

		close_command = 'bdelete! %d',
		right_mouse_command = 'bdelete! %d',
		left_mouse_command = 'bdelete! %d',

		indicator = {
			icon = '▎',
			style = 'underline',
		},
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',

		max_name_length = 16,
		max_prefix_length = 12,
		truncate_names = true,
		tab_size = 20,

		diagnostics = 'nvim_lsp',
		diagnostics_update_in_insert = false,
		diagnostics_indicator = diagnostics_indicator,

		color_icons = true,
		show_buffer_icons = true,
		show_buffer_close_icons = false,
		show_tab_indicators = true,

		show_duplicate_prefix = true,
		duplicates_across_groups = true,

		persist_buffer_sort = true,

		-- TODO: Configurate further.
	},
})
