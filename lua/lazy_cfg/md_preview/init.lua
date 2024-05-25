---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require("user")
local Check = User.check

local executable = Check.exists.executable

---@type table<string, string|number|table>
local Fields = {
	["mkdp_auto_start"] = 0,
	["mkdp_browser"] = executable("firefox") and "/usr/bin/firefox" or "",
	["mkdp_echo_preview_url"] = 1,
	["mkdp_open_to_the_world"] = 0,
	["mkdp_auto_close"] = 1,
	["mkdp_preview_options"] = {
		mkit = {},
		katex = {},
		uml = {},
		maid = {},
		disable_sync_scroll = 0,
		sync_scroll_type = "relative",
		hide_yaml_meta = 0,
		sequence_diagrams = {},
		flowchart_diagrams = {},
		content_editable = false,
		disable_filename = 0,
		toc = {},
	},
	["mkdp_filetypes"] = { "markdown" },
	["mkdp_theme"] = "dark",
}

for k, v in next, Fields do
	vim.g[k] = v
end

-- TODO: Setup keymaps
-- " normal/insert
-- <Plug>MarkdownPreview
-- <Plug>MarkdownPreviewStop
-- <Plug>MarkdownPreviewToggle
--
-- " example
-- nmap <C-s> <Plug>MarkdownPreview
-- nmap <M-s> <Plug>MarkdownPreviewStop
-- nmap <C-p> <Plug>MarkdownPreviewToggle
