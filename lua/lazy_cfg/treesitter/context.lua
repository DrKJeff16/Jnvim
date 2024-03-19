---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('treesitter-context') then
	return
end

local Context = require('treesitter.context')

vim.cmd[[
hi TreesitterContextBottom gui=underline guisp=Grey
hi TreesitterContextLineNumberBottom gui=underline guisp=Grey
]]

Context.setup({})
