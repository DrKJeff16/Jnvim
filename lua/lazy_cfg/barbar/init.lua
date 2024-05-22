---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local map_t = User.types.user.maps
local map = User.maps.map

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local desc = map.desc

if not exists('barbar') then
	return
end

local Bar = require('barbar')

Bar.setup()

-- TODO: Tweak options

-- vim.g, barbar_auto_setup = 0
--Bar.setup({
--	animation = false,
--	auto_hide = false,
--	tabpages = false,
--	clickable = false,

--	exclude_ft = {
--		'TelescopePrompt',
--		'lazy',
--	},

--	focus_on_close = 'previous',
--	hide = { inactive = false, extensions = false },

--	highlight_alternate = true,
--	highlight_inactive_file_icons = false,
--	highlight_visible = true,

--	icons = {
--		buffer_index = false,
--		buffer_number = false,

--		diagnostics = {
--			[vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
--			[vim.diagnostic.severity.WARN] = { enabled = true },
--			[vim.diagnostic.severity.INFO] = { enabled = false },
--			[vim.diagnostic.severity.HINT] = { enabled = false },
--		},

--		gitsigns = {
--			added = { enabled = true, icon = '+' },
--			changed = { enabled = true, icon = '~' },
--			deleted = { enabled = true, icon = '-' },
--		},

--		filetype = {
--			custom_colors = false,
--			enabled = true,
--		},

--		separator = { left = '▎', right = '' },
--		separator_at_end = true,

--		modified = { button = '●' },
--		pinned = { button = '', filename = true },

--		---@type 'default'|'powerline'|'slanted'
--		preset = 'default',

--		alternate = { filetype = { enabled = true } },
--		current = { buffer_index = false },
--		inactive = { button = '×' },
--		visible = { modified = { buffer_number = false } },
--	},

--	insert_at_end = false,
--	insert_at_start = false,

--	maximum_padding = 2,
--	minimum_padding = 1,
--	maximum_length = 32,
--	minimum_length = 0,

--	semantic_letters = true,

--	sidebar_filetypes = {
--		NvimTree = true,
--	},

--	letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

--	no_name_title = nil,
--})

---@type ApiMapDict
local Keys = {
	['<leader>Bp'] = { '<CMD>BufferPrevious<CR>', desc('Previous Buffer') },
	['<leader>Bn'] = { '<CMD>BufferNext<CR>', desc('Next Buffer') },
	['<leader>Bl'] = { '<CMD>BufferLast<CR>', desc('Last Buffer') },
	['<leader>Bf'] = { '<CMD>BufferFirst<CR>', desc('First Buffer') },
	['<leader>B1'] = { '<CMD>BufferGoto 1<CR>', desc('Goto Buffer 1') },
	['<leader>B2'] = { '<CMD>BufferGoto 2<CR>', desc('Goto Buffer 2') },
	['<leader>B3'] = { '<CMD>BufferGoto 3<CR>', desc('Goto Buffer 3') },
	['<leader>B4'] = { '<CMD>BufferGoto 4<CR>', desc('Goto Buffer 4') },
	['<leader>B5'] = { '<CMD>BufferGoto 5<CR>', desc('Goto Buffer 5') },
	['<leader>B6'] = { '<CMD>BufferGoto 6<CR>', desc('Goto Buffer 6') },
	['<leader>B7'] = { '<CMD>BufferGoto 7<CR>', desc('Goto Buffer 7') },
	['<leader>B8'] = { '<CMD>BufferGoto 8<CR>', desc('Goto Buffer 8') },
	['<leader>B9'] = { '<CMD>BufferGoto 9<CR>', desc('Goto Buffer 9') },
	['<leader>BMp'] = { '<CMD>BufferMovePrevious<CR>', desc('Move Previous Buffer') },
	['<leader>BMn'] = { '<CMD>BufferMoveNext<CR>', desc('Move Next Buffer') },
	['<leader>Bd'] = { '<CMD>BufferClose<CR>', desc('Close Buffer') },
	['<leader>B<C-p>'] = { '<CMD>BufferPin<CR>', desc('Pin Buffer') },
	['<leader>B<C-P>'] = { '<CMD>BufferPick<CR>', desc('Pick Buffer') },
	['<leader>B<C-b>'] = { '<CMD>BufferOrderByBufferNumber<CR>', desc('Order Buffer By Number') },
	['<leader>B<C-d>'] = { '<CMD>BufferOrderByDirectory<CR>', desc('Order Buffer By Directory') },
	['<leader>B<C-l>'] = { '<CMD>BufferOrderByLanguage<CR>', desc('Order Buffer By Language') },
	['<leader>B<C-n>'] = { '<CMD>BufferOrderByName<CR>', desc('Order Buffer By Name') },
	['<leader>B<C-w>'] = { '<CMD>BufferOrderByWindowNumber<CR>', desc('Order Buffer By Window Number') },
}

for lhs, v in next, Keys do
	v[2] = is_tbl(v[2]) and v[2] or {}
	map.n(lhs, v[1], v[2])
end
