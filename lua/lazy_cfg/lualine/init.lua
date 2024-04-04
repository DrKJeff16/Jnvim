---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('lualine') then
	return
end

---@type string[]
local submodules = {
	'bufferline',
}

---@param subs string[]
---@return table<string, fun(...): any> res
local src = function(subs)
	local prefix = 'lazy_cfg.lualine.'

	---@type table<string, any>
	local res = {}

	for _, v in next, subs do
		local path = prefix..v
		if exists(path) then
			res[path] = function()
				require(path)
			end
		end
	end

	return res
end

local Lualine = require('lualine')

Lualine.setup({
	options = {
		icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = false,
        globalstatus = true,
        refresh = {
            statusline = 500,
            tabline = 500,
            winbar = 500,
        },
    },
    sections = {
        lualine_a = {
			{
				'mode',
				---@param str string
				---@return string
				fmt = function(str)
					return str:sub(1,1)
				end,
			},
        },
        lualine_b = {
			'branch',
			-- 'diff',
			{
				'diagnostics',
				sources = { 'nvim_lsp' },
				sections = { 'error', 'warn' },
				symbols = {
					error = 'E',
					warn = 'W',
					info = 'I',
					hint = '?'
				},
			},
        },
        lualine_c = {
			{
				'filename',
				file_status = true,
				newfile_status = true,
				path = 1,
				shorting_target = 15,
				symbold = {
					modified = '[+]',
					readonly = '[RO]',
					unnamed = '[NONAME]',
					newfile = '[NEW]'
				},
			},
		},
        lualine_x = {
			'encoding',
			'fileformat',
			{
				'filetype',
				icon_only = false,
				icon = { '', align = 'right' },
			}
		},
        lualine_y = {
			'progress',
			-- { 'searchcount', timeout = 10 }
        },
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_winbar = {},
    extensions = {}
})

local subs = src(submodules)
if subs.bufferline then
	subs.bufferline()
end
