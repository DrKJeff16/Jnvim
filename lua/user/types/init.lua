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

---@alias ApiMapOpts vim.api.keyset.keymap
---@alias KeyMapOpts vim.keymap.set.Opts

---@alias MapOpts ApiMapOpts|KeyMapOpts

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

---@type 'user.types.'
local pfx = 'user.types.'

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
local M = {}

local subs = {
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

for _, v in next, subs do
	local path = pfx..v
	local ok, _ = pcall(require, path)
	if ok then
		---@return any
		M[v] = require(path)
	end
end

return M
