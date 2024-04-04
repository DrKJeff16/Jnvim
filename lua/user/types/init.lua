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

---@class OptionPairTbl
---@field hid? boolean
---@field hlg? string
---@field spell? boolean
---@field mouse? string
---@field bs? string
---@field formatoptions? string
---@field enc? string
---@field fenc? string
---@field ff? 'unix'|'dos'
---@field wrap? boolean
---@field completeopt? string
---@field errorbells? boolean
---@field visualbell? boolean
---@field belloff? string
---@field nu? boolean
---@field relativenumber? boolean
---@field signcolumn? 'yes'|'no'|'auto'|'number'
---@field ts? integer
---@field sts? integer
---@field sw? integer
---@field ai? boolean
---@field si? boolean
---@field sta? boolean
---@field ci? boolean
---@field pi? boolean
---@field et? boolean
---@field bg? string
---@field tgc? boolean
---@field splitbelow? boolean
---@field splitright? boolean
---@field ru? boolean
---@field stal? integer
---@field ls? integer
---@field title? boolean
---@field showcmd? boolean
---@field wildmenu? boolean
---@field showmode? boolean
---@field ar? boolean
---@field confirm? boolean
---@field smartcase? boolean
---@field ignorecase? boolean
---@field hlsearch? boolean
---@field incsearch? boolean
---@field showmatch? boolean

---@class OptPairTbl
---@field completeopt? string[]
---@field termguicolors? boolean

---@class OptsTbl
---@field set? OptionPairTbl
---@field opt? OptPairTbl
---|table

require('user.types.user.maps')
require('user.types.user.highlight')

---@class UserMod
---@field pfx string
---@field opts fun()
---@field exists fun(mod: string): boolean
---@field assoc fun()
---@field maps fun(): UserMaps
---@field highlight fun(): UserHl

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
		'highlight',
		'autocmd',
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
