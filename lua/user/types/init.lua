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

---@alias MapOpts vim.api.keyset.keymap

---@class OptsTbl
---@field set? OptPairTbl
---@field opt? OptPairTbl
---|table

---@class MapTbl
---@field lhs string
---@field rhs string
---@field opts? MapOpts

---@class UserOptsMod
---@field pfx? string
---@field __index? UserOptsMod
---@field opt_tbl OptsTbl
---@field new? fun(): UserOptsMod
---@field optset fun(opts: OptPairTbl, vim_tbl?: table)
---@field setup? fun(self?: UserOptsMod)

---@class UserMod
---@field pfx? string
---@field cond? table
---@field opts fun(): UserOptsMod
---@field new fun(self: UserMod, prefix?: string): UserMod
---@field multisrc? fun(self: UserMod, mods: ModTbl, prefix: string): any
---@field exists fun(mod: string): boolean
---@field assoc fun()

local pfx = 'user.types.'

---@param subs string[]
---@param prefix? string
---@return table<string, fun(): any> res
local src = function(subs, prefix)
	prefix = prefix or pfx

	---@type table<string, fun(): any>
	local res = {}

	for _, v in next, subs do
		local path = prefix..v
		local ok, _ = pcall(require, path)
		if ok then
			---@return any
			res[v] = function()
				return require(path)
			end
		end
	end

	return res
end

---@type string[]
local submods = {
	'lspconfig',
	'cmp',
	'treesitter',
	'opts',
	'nvim_tree',
	'todo_comments',
}

local subs = src(submods)

if #subs > 0 then
	for _, v in next, subs do
		v()
	end
end
