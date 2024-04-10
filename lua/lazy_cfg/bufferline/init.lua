---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('bufferline') then
	return
end

local BLine = require('bufferline')

---@param count integer
---@param lvl 'error'|'warning'
---@param diags? table<string, any>
---@param context? table
---@return string
local diagnostics_indicator = function(count, lvl, diags, context)
	if not context.buffer:current() then
		return ''
	end

	local s = " "

	for e, n in next, diags do
		local sym = e == "error" and " "
		or (e == "warning" and " " or "" )
		s = s .. n .. sym
	end

	return s
end

---@type bufferline.UserConfig
local opts = {
	options = {
		mode = 'buffers',

		style_preset = {
			BLine.style_preset.no_italic,
			BLine.style_preset.minimal,
		},
		themable = true,

		numbers = 'buffer_id',

		close_command = 'bdelete! %d',
		right_mouse_command = 'bdelete! %d',
		left_mouse_command = 'bdelete! %d',

		indicator = {
			icon = '▎',
			style = 'icon',
		},

        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',

		max_name_length = 20,
		max_prefix_length = 15,
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
		duplicates_across_groups = false,

		persist_buffer_sort = false,

		-- TODO: Configurate further.
	},
}

BLine.setup(opts)
