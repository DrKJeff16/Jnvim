---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists
local map_t = User.types.user.maps
local map = User.maps.map

local nmap = map.n

if not exists('barbar') then
	return
end

local let = vim.g

let.barbar_auto_setup = false

local Bar = require('barbar')

Bar.setup({
	animation = false,
	auto_hide = false,
	tabpages = true,
	clickable = false,
	focus_on_close = 'left',
	hide = { extensions = false, inactive = false },
	highlight_alternate = false,
	highlight_visible = true,

	icons = {
		buffer_index = false,
		buffer_number = true,

		button = '',
    	-- Enables / disables diagnostic symbols
    	diagnostics = {
      		[vim.diagnostic.severity.ERROR] = { enabled = true },
      		[vim.diagnostic.severity.WARN] = { enabled = true },
      		[vim.diagnostic.severity.INFO] = { enabled = false },
      		[vim.diagnostic.severity.HINT] = { enabled = false },
    	},
    	gitsigns = {
      		added = {enabled = true, icon = '+'},
      		changed = {enabled = true, icon = '~'},
      		deleted = {enabled = true, icon = '-'},
    	},
    	filetype = {
      		-- Sets the icon's highlight group.
      		-- If false, will use nvim-web-devicons colors
      		custom_colors = false,

      		-- Requires `nvim-web-devicons` if `true`
      		enabled = true,
    	},
    	separator = { left = '▎', right = '' },

    	-- If true, add an additional separator at the end of the buffer list
    	separator_at_end = true,

    	-- Configure the icons on the bufferline when modified or pinned.
    	-- Supports all the base icon options.
    	modified = { button = '●' },
    	pinned = { button = '', filename = true },

    	-- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
    	preset = 'powerline',

    	-- Configure the icons on the bufferline based on the visibility of a buffer.
    	-- Supports all the base icon options, plus `modified` and `pinned`.
    	alternate = {filetype = {enabled = true}},
    	current = {buffer_index = true},
    	inactive = {button = '×'},
    	visible = {modified = {buffer_number = false}},
	},

	-- If true, new buffers will be inserted at the start/end of the list.
  	-- Default is to insert after current buffer.
  	insert_at_end = false,
  	insert_at_start = false,

  	-- Sets the maximum padding width with which to surround each tab
  	maximum_padding = 1,

  	-- Sets the minimum padding width with which to surround each tab
  	minimum_padding = 0,

  	-- Sets the maximum buffer name length.
  	maximum_length = 16,

  	-- Sets the minimum buffer name length.
  	minimum_length = 0,

  	-- If set, the letters for each buffer in buffer-pick mode will be
  	-- assigned based on their name. Otherwise or in case all letters are
  	-- already assigned, the behavior is to assign letters in order of
  	-- usability (see order below)
  	semantic_letters = true,

  	-- Set the filetypes which barbar will offset itself for
  	sidebar_filetypes = {
    	-- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
    	NvimTree = true,
	},

	no_name_title = 'N    E    W',
})

local Keys = {
	{ ['<A-,>'] = '<Cmd>BufferPrevious<CR>' },
	{ ['<A-.>'] = '<Cmd>BufferNext<CR>' },
	{ ['<A-<>'] = '<Cmd>BufferMovePrevious<CR>' },
	{ ['<A->>'] = '<Cmd>BufferMoveNext<CR>' },
	{ ['<A-1>'] = '<Cmd>BufferGoto 1<CR>' },
	{ ['<A-2>'] = '<Cmd>BufferGoto 2<CR>' },
	{ ['<A-3>'] = '<Cmd>BufferGoto 3<CR>' },
	{ ['<A-4>'] = '<Cmd>BufferGoto 4<CR>' },
	{ ['<A-5>'] = '<Cmd>BufferGoto 5<CR>' },
	{ ['<A-6>'] = '<Cmd>BufferGoto 6<CR>' },
	{ ['<A-7>'] = '<Cmd>BufferGoto 7<CR>' },
	{ ['<A-8>'] = '<Cmd>BufferGoto 8<CR>' },
	{ ['<A-9>'] = '<Cmd>BufferGoto 9<CR>' },
	{ ['<A-0>'] = '<Cmd>BufferLast<CR>' },
	{ ['<A-p>'] = '<Cmd>BufferPin<CR>' },
	{ ['<A-c>'] = '<Cmd>BufferClose<CR>' },
	{ ['<C-p>'] = '<Cmd>BufferPick<CR>' },
	{ ['<Space>Bb'] = '<Cmd>BufferOrderByBufferNumber<CR>' },
	{ ['<Space>Bn'] = '<Cmd>BufferOrderByName<CR>' },
	{ ['<Space>Bd'] = '<Cmd>BufferOrderByDirectory<CR>' },
	{ ['<Space>Bl'] = '<Cmd>BufferOrderByLanguage<CR>' },
	{ ['<Space>Bw'] = '<Cmd>BufferOrderByWindowNumber<CR>' },
}

for _, val in next, Keys do
	for k, v in next, val do
		nmap(k, v, {})
	end
end
