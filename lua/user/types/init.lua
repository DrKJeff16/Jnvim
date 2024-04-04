---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias ModTbl
---|string[]
---|{ [string]: string }
---|table<string, boolean>

---@class CheckerOpts

---@class CheckerOptsExtended: CheckerOpts

---@class VimExistance
---@field global fun(g: string|string[]): boolean
---@field global_opt fun(field: string|string[], tbl: table?): boolean
---@field buf_opt fun(field: string|string[], bufnr: integer?): boolean
---@field api_field fun(field: string|string[]): boolean

---@class ExistanceCheck
---@field module fun(mod: string): boolean
---@field data fun(v: any|unknown): boolean
---@field field fun(field: string, t: table|table[]): boolean
---@field vim VimExistance

---@class ValueCheck
---@field empty fun(v: string|table|number): boolean
---@field lt fun(v: string|table|number, opts: CheckerOpts?): boolean
---@field gt fun(v: string|table|number, opts: CheckerOpts?): boolean
---@field eq fun(v: string|table|number, opts: CheckerOptsExtended?): boolean
---@field has_val fun(t: table, opts: CheckerOptsExtended): boolean

---@class UserCheck
---@field exists ExistanceCheck
---@field value ValueCheck
---@field dry_run fun(f: fun(), ...): any

---@class UserMod
---@field exists fun(mod: string): boolean
---@field assoc fun()
---@field maps UserMaps
---@field highlight UserHl
---@field opts fun(): any|unknown

---@class UserSubTypes
---@field maps any
---@field highlight any
---@field autocmd any
---@field opts any

---@class UserTypes
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

---@type UserTypes
local M = {}

---@param str
---|string
---|table<integer, string>
---@param prefix string
---@return UserSubTypes res
local function filter_sub_src(str, prefix)
	if type(str) == 'string' then
		error('String exception in `user.types.init`.')
	end

	---@type UserSubTypes
	local res = {}

	for _, s in next, str do
		local path = prefix..s
		local exists, m = pcall(require, path)
		if exists then
			res[s] = m
		end
	end

	return res
end

---@param str
---|table<integer, string>
---|table<string, table<integer, string>>
---@return UserTypes res
local function filter_src(str)
	local prefix = 'user.types.'

	---@type UserTypes
	local res = {}
	for k, s in next, str do
		if type(k) == 'integer' then
			local path = prefix..s
			local exists, m = pcall(require, path)
			if exists then
				res[s] = m
			end
		elseif type(k) == 'string' then
			res[k] = filter_sub_src(s, prefix..k..'.')
		end
	end

	return res
end

local submods = {
	user = {
		'maps',
		'highlight',
		'autocmd',
		'opts',
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

M = filter_src(submods)

return M
