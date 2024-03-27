---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('lualine') then
	return
end

local pfx = 'lazy_cfg.lualine.'

---@type string[]
local submodules = {
	'bufferline',
}

---@param subs string[]
---@param prefix? string
---@return table<string, any>
local src = function(subs, prefix)
	if not prefix or type(prefix) ~= 'string' or prefix == '' then
		prefix = pfx
	end

	local path = ''
	local cond = false

	---@type table<string, any>
	local res = {}

	for _, v in next, subs do
		path = prefix..v
		cond = exists(path)
		if cond then
			res[path] = require(path)
		end
	end

	return res
end

local Lualine = require('lualine')

Lualine.setup({
	options = {
		icons_enabled = false,
        theme = 'tokyonight',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
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

src(submodules)
