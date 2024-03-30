---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias VimOption
---|string
---|number
---|boolean
---|table

---@alias ModTbl
---|string[]
---|{ [string]: string }
---|table<string, boolean>

---@alias OptPairTbl table<string, VimOption>

---@class OptsTbl
---@field set? OptPairTbl
---@field opt? OptPairTbl
---|table

---@class UserOptsMod
---@field pfx? string
---@field __index? UserOptsMod
---@field opt_tbl OptsTbl
---@field new? fun(): UserOptsMod
---@field optset fun(opts: OptPairTbl, vim_tbl?: table)
---@field setup? fun(self?: UserOptsMod)

require('user.types.user.maps')

---@class UserMod
---@field pfx? string
---@field cond? table
---@field opts fun(): UserOptsMod
---@field new fun(self: UserMod, prefix?: string): UserMod
---@field multisrc? fun(self: UserMod, mods: ModTbl, prefix: string): any
---@field exists fun(mod: string): boolean
---@field assoc fun()

---@type 'user.types.'
local pfx = 'user.types.'

---@class UserSubTypes
---@field maps UserMaps

---@class UserTypesMod
---@field lspconfig? any
---@field cmp? any
---@field gitsigns? any
---@field colorschemes? any
---@field treesitter? any
---@field opts? any
---@field nvim_tree? any
---@field todo_comments? any
---@field which_key? any
---@field user? UserSubTypes
local M = {}

local submods = {
	['user'] = {
		'maps',
	},
	'lspconfig',
	'cmp',
	'gitsigns',
	'colorschemes',
	'treesitter',
	'opts',
	'nvim_tree',
	'todo_comments',
	'which_key'
}

---@param subs string[]|table<string, string[]>
---@param prefix? string
---@return UserTypesMod|UserSubTypes
 function src(subs, prefix)
	prefix = prefix or ''

	---@type UserTypesMod|UserSubTypes
	local res = {}

	for k, v in next, subs do
		if type(k) == 'string' and type(v) == 'table' then
			res[k] = src(v, prefix..k..'.')
		else
			local path = 'user.types.'..prefix..v
			local ok, _ = pcall(require, path)
			if ok then
				res[prefix..v] = require(path)
			end
		end
	end

	return res
end

for k, v in next, src(submods) do
	M[k] = v
end

return M
