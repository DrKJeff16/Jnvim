---@diagnostic disable:unused-function
---@diagnostic disable:unused-label

local User = require('user')
local Check = User.check
local maps_t = User.types.user.maps
local kmap = User.maps.kmap

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local nmap = kmap.n
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

---@type KeyMapDict
local Keys = {
	['<leader>Sr'] = { Pst.load, desc('Restore Session') },
	['<leader>Sd'] = { Pst.stop, desc("Don't Save Current Session") },
	['<leader>Sl'] = {
		function()
			Pst.load({ last = true })
		end,
		desc('Restore Last Session'),
	},
}

for lhs, v in next, Keys do
	v[2] = is_tbl(v[2]) and v[2] or {}
	nmap(lhs, v[1], v[2])
end
