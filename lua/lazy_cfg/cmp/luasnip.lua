---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.exists

if not exists('luasnip') then
	return
end

local pfx = 'lazy_cfg.cmp.'

local Luasnip = require('luasnip')

if exists("luasnip.loaders.from_vscode") then
	require('luasnip.loaders.from_vscode').lazy_load()
end

return Luasnip
