---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local map_t = User.types.user.maps
local map = User.maps.map

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl

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
	['<leader>B<A-,>'] = { '<CMD>BufferPrevious<CR>' },
	['<leader>B<A-.>'] = { '<CMD>BufferNext<CR>' },
	['<leader>B<A-0>'] = { '<CMD>BufferLast<CR>' },
	['<leader>B<A-1>'] = { '<CMD>BufferGoto 1<CR>' },
	['<leader>B<A-2>'] = { '<CMD>BufferGoto 2<CR>' },
	['<leader>B<A-3>'] = { '<CMD>BufferGoto 3<CR>' },
	['<leader>B<A-4>'] = { '<CMD>BufferGoto 4<CR>' },
	['<leader>B<A-5>'] = { '<CMD>BufferGoto 5<CR>' },
	['<leader>B<A-6>'] = { '<CMD>BufferGoto 6<CR>' },
	['<leader>B<A-7>'] = { '<CMD>BufferGoto 7<CR>' },
	['<leader>B<A-8>'] = { '<CMD>BufferGoto 8<CR>' },
	['<leader>B<A-9>'] = { '<CMD>BufferGoto 9<CR>' },
	['<leader>B<A-<>'] = { '<CMD>BufferMovePrevious<CR>' },
	['<leader>B<A->>'] = { '<CMD>BufferMoveNext<CR>' },
	['<leader>B<A-c>'] = { '<CMD>BufferClose<CR>' },
	['<leader>B<A-p>'] = { '<CMD>BufferPin<CR>' },
	['<leader>B<C-p>'] = { '<CMD>BufferPick<CR>' },
	['<leader>Bb'] = { '<CMD>BufferOrderByBufferNumber<CR>' },
	['<leader>Bd'] = { '<CMD>BufferOrderByDirectory<CR>' },
	['<leader>Bl'] = { '<CMD>BufferOrderByLanguage<CR>' },
	['<leader>Bn'] = { '<CMD>BufferOrderByName<CR>' },
	['<leader>Bw'] = { '<CMD>BufferOrderByWindowNumber<CR>' },
}

for lhs, v in next, Keys do
	if not is_tbl(v[2]) then
		v[2] = {}
	end
	map.n(lhs, v[1], v[2])
end
