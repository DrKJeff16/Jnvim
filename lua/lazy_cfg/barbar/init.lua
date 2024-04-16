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

local Bar = require('barbar')

Bar.setup()

local Keys = {
	{ ['<leader>B<A-,>'] = '<CMD>BufferPrevious<CR>' },
	{ ['<leader>B<A-.>'] = '<CMD>BufferNext<CR>' },
	{ ['<leader>B<A-0>'] = '<CMD>BufferLast<CR>' },
	{ ['<leader>B<A-1>'] = '<CMD>BufferGoto 1<CR>' },
	{ ['<leader>B<A-2>'] = '<CMD>BufferGoto 2<CR>' },
	{ ['<leader>B<A-3>'] = '<CMD>BufferGoto 3<CR>' },
	{ ['<leader>B<A-4>'] = '<CMD>BufferGoto 4<CR>' },
	{ ['<leader>B<A-5>'] = '<CMD>BufferGoto 5<CR>' },
	{ ['<leader>B<A-6>'] = '<CMD>BufferGoto 6<CR>' },
	{ ['<leader>B<A-7>'] = '<CMD>BufferGoto 7<CR>' },
	{ ['<leader>B<A-8>'] = '<CMD>BufferGoto 8<CR>' },
	{ ['<leader>B<A-9>'] = '<CMD>BufferGoto 9<CR>' },
	{ ['<leader>B<A-<>'] = '<CMD>BufferMovePrevious<CR>' },
	{ ['<leader>B<A->>'] = '<CMD>BufferMoveNext<CR>' },
	{ ['<leader>B<A-c>'] = '<CMD>BufferClose<CR>' },
	{ ['<leader>B<A-p>'] = '<CMD>BufferPin<CR>' },
	{ ['<leader>B<C-p>'] = '<CMD>BufferPick<CR>' },
	{ ['<leader>Bb'] = '<CMD>BufferOrderByBufferNumber<CR>' },
	{ ['<leader>Bd'] = '<CMD>BufferOrderByDirectory<CR>' },
	{ ['<leader>Bl'] = '<CMD>BufferOrderByLanguage<CR>' },
	{ ['<leader>Bn'] = '<CMD>BufferOrderByName<CR>' },
	{ ['<leader>Bw'] = '<CMD>BufferOrderByWindowNumber<CR>' },
}

for _, val in next, Keys do
	for k, v in next, val do
		nmap(k, v, {})
	end
end
