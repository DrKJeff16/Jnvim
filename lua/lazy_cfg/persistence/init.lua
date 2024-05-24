---@diagnostic disable:unused-function
---@diagnostic disable:unused-label

local User = require('user')
local Check = User.check
local maps_t = User.types.user.maps
local kmap = User.maps.kmap

local exists = Check.exists.module
local nmap = kmap.n
local desc = kmap.desc

if not exists('persistence') then
	return
end

local Pst = require('persistence')

local Opts = {
	options = vim.opt.sessionoptions:get(),
}

Pst.setup(Opts)

-- stylua: ignore
---@type KeyMapDict
local Keys = {
	['<leader>Sr'] = {
		Pst.load,
		desc('Restore Session'),
	},
	['<leader>Sl'] = {
		function()
			Pst.load({ last = true })
		end,
		desc('Restore Last Session'),
	},
	['<leader>Sd'] = {
		Pst.stop,
		desc('Don\'t Save Current Session'),
	},
}
