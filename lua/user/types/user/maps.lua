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

---@class UserKeyMaps
---@field n fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)
---@field v fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)
---@field t fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)
---@field i fun(lhs: string, rhs: Rhs, opts: KeyMapOpts?)

---@class UserMaps
---@field kmap UserKeyMaps
---@field map UserApiMaps
