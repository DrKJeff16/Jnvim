---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local maps_t = User.types.user.maps
local kmap = User.maps.kmap
local WK = User.maps.wk

local desc = kmap.desc

local executable = Check.exists.executable
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty

local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

---@type table<string, string|number|table>
local Fields = {
	['mkdp_auto_start'] = 0,
	['mkdp_browser'] = executable('firefox') and '/usr/bin/firefox' or '',
	['mkdp_echo_preview_url'] = 1,
	['mkdp_open_to_the_world'] = 0,
	['mkdp_auto_close'] = 1,
	['mkdp_preview_options'] = {
		mkit = {},
		katex = {},
		uml = {},
		maid = {},
		disable_sync_scroll = 0,
		sync_scroll_type = 'relative',
		hide_yaml_meta = 0,
		sequence_diagrams = {},
		flowchart_diagrams = {},
		content_editable = false,
		disable_filename = 0,
		toc = {},
	},
	['mkdp_filetypes'] = { 'markdown' },
	['mkdp_theme'] = 'dark',
}

for k, v in next, Fields do
	vim.g[k] = v
end

au({ 'BufNew', 'BufWinEnter', 'BufEnter', 'BufRead' }, {
	group = augroup('MarkdownPreviewInitHook', { clear = true }),
	pattern = '*.md',
	callback = function()
		---@type table<MapModes, KeyMapDict>
		local Keys = {
			n = {
				['<leader>f<C-m>t'] = {
					function()
						vim.cmd('MarkdownPreviewToggle')
					end,
					desc('Toggle Markdown Preview'),
				},
				['<leader>f<C-m>p'] = {
					function()
						vim.cmd('MarkdownPreview')
					end,
					desc('Run Markdown Preview'),
				},
				['<leader>f<C-m>s'] = {
					function()
						vim.cmd('MarkdownPreviewStop')
					end,
					desc('Stop Markdown Preview'),
				},
			},
			v = {
				['<leader>f<C-m>t'] = {
					function()
						vim.cmd('MarkdownPreviewToggle')
					end,
					desc('Toggle Markdown Preview'),
				},
				['<leader>f<C-m>p'] = {
					function()
						vim.cmd('MarkdownPreview')
					end,
					desc('Run Markdown Preview'),
				},
				['<leader>f<C-m>s'] = {
					function()
						vim.cmd('MarkdownPreviewStop')
					end,
					desc('Stop Markdown Preview'),
				},
			},
		}

		---@type table<MapModes, RegKeysNamed>
		local Names = {
			n = { ['<leader>f<C-m>'] = { name = '+MarkdownPreview' } },
			v = { ['<leader>f<C-m>'] = { name = '+MarkdownPreview' } },
		}

		local bufnr = vim.api.nvim_get_current_buf()

		for mode, t in next, Keys do
			if WK.available() then
				if is_tbl(Names[mode]) and not empty(Names[mode]) then
					WK.register(Names[mode], { mode = mode, buffer = bufnr })
				end

				WK.register(WK.convert_dict(t), { mode = mode, buffer = bufnr })
			else
				for lhs, v in next, t do
					v[2] = is_tbl(v[2]) and v[2] or {}

					kmap[mode](lhs, v[1], v[2])
				end
			end
		end
	end,
})
