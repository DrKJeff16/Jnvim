---@diagnostic disable:unused-function
---@diagnostic disable:unused-label

local User = require('user')
local Check = User.check
local maps_t = User.types.user.maps
local kmap = User.maps.kmap
local WK = User.maps.wk

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local desc = kmap.desc

if not exists('persistence') then
	return
end

local expand = vim.fn.expand
local stdpath = vim.fn.stdpath

local Pst = require('persistence')

local Opts = {
	options = vim.opt.sessionoptions:get(),
	dir = expand(stdpath('state') .. '/sessions/'), -- directory where session files are saved
	pre_save = not exists('barbar') and nil or function()
		vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' })
	end, -- a function to call before saving the session
	post_save = nil, -- a function to call after saving the session
	save_empty = false, -- don't save if there are no open file buffers
	pre_load = nil, -- a function to call before loading the session
	post_load = nil, -- a function to call after loading the session
}

Pst.setup(Opts)

---@type table<MapModes, KeyMapDict>
local Keys = {
	n = {
		['<leader>Sr'] = { Pst.load, desc('Restore Session') },
		['<leader>Sd'] = { Pst.stop, desc("Don't Save Current Session") },
		['<leader>Sl'] = {
			function()
				Pst.load({ last = true })
			end,
			desc('Restore Last Session'),
		},
	},
	v = {
		['<leader><C-S>r'] = { Pst.load, desc('Restore Session') },
		['<leader><C-S>d'] = { Pst.stop, desc("Don't Save Current Session") },
		['<leader><C-S>l'] = {
			function()
				Pst.load({ last = true })
			end,
			desc('Restore Last Session'),
		},
	},
}

---@type table<MapModes, RegKeysNamed>
local Names = {
	n = { ['<leader>S'] = { name = '+Session (Persistence)' } },
	v = { ['<leader><C-S>'] = { name = '+Session (Persistence)' } },
}

for mode, t in next, Keys do
	if WK.available() then
		if is_tbl(Names[mode]) and not empty(Names[mode]) then
			WK.register(Names[mode], { mode = mode })
		end

		WK.register(WK.convert_dict(t), { mode = mode })
	else
		for lhs, v in next, t do
			v[2] = is_tbl(v[2]) and v[2] or {}
			kmap[mode](lhs, v[1], v[2])
		end
	end
end
