---@alias ApiMapOpts vim.api.keyset.keymap
---@alias KeyMapOpts vim.keymap.set.Opts
---@alias Rhs string|fun()

---@class MapTbl
---@field lhs string
---@field rhs string
---@field opts? ApiMapOpts

---@class KeyMapTbl: MapTbl
---@field rhs string|fun()
---@field opts? KeyMapOpts

---@alias ApiMapFunction fun(lhs: string, rhs: string, opts?: ApiMapOpts)
---@alias KeyMapFunction fun(lhs: string, rhs: string|fun(), opts?: KeyMapOpts)
---@alias BufMapFunction fun(b: integer, lhs: string, rhs: string, opts?: ApiMapOpts)

---@class UserApiMaps
---@field n  ApiMapFunction
---@field v  ApiMapFunction
---@field t  ApiMapFunction
---@field i  ApiMapFunction
---@field o? ApiMapFunction
---@field x? ApiMapFunction

---@class UserKeyMaps: UserApiMaps
---@field n  KeyMapFunction
---@field v  KeyMapFunction
---@field t  KeyMapFunction
---@field i  KeyMapFunction
---@field o? KeyMapFunction
---@field x? KeyMapFunction

---@class UserBufMaps: UserApiMaps
---@field n BufMapFunction
---@field v BufMapFunction
---@field t BufMapFunction
---@field i BufMapFunction
---@field o BufMapFunction
---@field x BufMapFunction

---@class UserBufModeKeys
---@field n? MapTbl[]
---@field i? MapTbl[]
---@field v? MapTbl[]
---@field t? MapTbl[]
---@field o? MapTbl[]
---@field x? MapTbl[]

---@class UserMaps
---@field kmap UserKeyMaps
---@field map UserApiMaps
---@field buf_map UserBufMaps
