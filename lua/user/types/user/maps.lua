---@alias ApiMapOpts vim.api.keyset.keymap
---@alias KeyMapOpts vim.keymap.set.Opts
---@alias KeyRhs string|fun()
---@alias ApiRhs string

---@class ApiMapRhsOptsArr
---@field [1] ApiRhs
---@field [2]? ApiMapOpts

---@class ApiMapRhsOptsDict
---@field rhs ApiRhs
---@field opts? ApiMapOpts

---@class KeyMapRhsOptsArr: ApiMapRhsOptsArr
---@field [1] KeyRhs
---@field [2]? KeyMapOpts

---@class KeyMapRhsOptsDict: ApiMapRhsOptsDict
---@field rhs KeyRhs
---@field opts? KeyMapOpts

---@class ApiMapTbl
---@field lhs string
---@field rhs string
---@field opts? ApiMapOpts

---@class MapTbl: ApiMapTbl

---@class KeyMapTbl: ApiMapTbl
---@field rhs string|fun()
---@field opts? KeyMapOpts

---@alias ApiMapFunction fun(lhs: string, rhs: string, opts: ApiMapOpts?)
---@alias KeyMapFunction fun(lhs: string, rhs: string|fun(), opts: KeyMapOpts?)
---@alias BufMapFunction fun(b: integer, lhs: string, rhs: string, opts: ApiMapOpts?)

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
---@field o? BufMapFunction
---@field x? BufMapFunction

---@class UserBufModeKeys
---@field n ApiMapTbl[]
---@field i ApiMapTbl[]
---@field v ApiMapTbl[]
---@field t ApiMapTbl[]
---@field o? ApiMapTbl[]
---@field x? ApiMapTbl[]

---@alias ApiMapDict table<string, ApiMapRhsOptsArr>
---@alias ApiMapDicts table<string, ApiMapRhsOptsDict>
---@alias KeyMapDict table<string, KeyMapRhsOptsArr>
---@alias KeyMapDicts table<string, KeyMapRhsOptsDict>

---@class UserMaps
---@field kmap UserKeyMaps
---@field map UserApiMaps
---@field buf_map UserBufMaps
