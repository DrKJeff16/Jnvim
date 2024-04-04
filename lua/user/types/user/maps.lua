---@alias ApiMapOpts vim.api.keyset.keymap
---@alias KeyMapOpts vim.keymap.set.Opts
---@alias Rhs string|fun(...)

---@class MapTbl
---@field lhs string
---@field rhs string
---@field opts? ApiMapOpts

---@class UserApiMaps
---@field n fun(lhs: string, rhs: string, opts: ApiMapOpts?)
---@field v fun(lhs: string, rhs: string, opts: ApiMapOpts?)
---@field t fun(lhs: string, rhs: string, opts: ApiMapOpts?)
---@field i fun(lhs: string, rhs: string, opts: ApiMapOpts?)
---@field o fun(lhs: string, rhs: string, opts: ApiMapOpts?)
---@field x fun(lhs: string, rhs: string, opts: ApiMapOpts?)

---@class UserKeyMaps: UserApiMaps
---@field n fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)
---@field v fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)
---@field t fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)
---@field i fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)
---@field o? fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)
---@field x? fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)

---@class UserBufMaps: UserApiMaps
---@field n fun(b: integer, lhs: string, rhs: string, opts: ApiMapOpts?)
---@field v fun(b: integer, lhs: string, rhs: string, opts: ApiMapOpts?)
---@field t fun(b: integer, lhs: string, rhs: string, opts: ApiMapOpts?)
---@field i fun(b: integer, lhs: string, rhs: string, opts: ApiMapOpts?)
---@field o fun(b: integer, lhs: string, rhs: string, opts: ApiMapOpts?)
---@field x fun(b: integer, lhs: string, rhs: string, opts: ApiMapOpts?)

---@class UserMaps
---@field kmap UserKeyMaps
---@field map UserApiMaps
---@field buf_map UserBufMaps
