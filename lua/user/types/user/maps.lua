---@alias ApiMapOpts vim.api.keyset.keymap
---@alias KeyMapOpts vim.keymap.set.Opts
---@alias BufMapOpts ApiMapOpts
---@alias KeyRhs string|fun()
---@alias ApiRhs string

---@class ApiMapRhsOptsArr
---@field [1] ApiRhs
---@field [2]? ApiMapOpts

---@class KeyMapRhsOptsArr: ApiMapRhsOptsArr
---@field [1] KeyRhs
---@field [2]? KeyMapOpts

---@class ApiMapRhsOptsDict
---@field rhs ApiRhs
---@field opts? ApiMapOpts

---@class KeyMapRhsOptsDict: ApiMapRhsOptsDict
---@field rhs KeyRhs
---@field opts? KeyMapOpts

---@class ApiMapArr
---@field [1] string
---@field [2] string
---@field [3]? ApiMapOpts

---@class BufMapArr: ApiMapArr

---@class KeyMapArr: ApiMapArr
---@field [1] string
---@field [2] string
---@field [3]? KeyMapOpts

---@alias ApiMapDict table<string, ApiMapRhsOptsArr>
---@alias ApiMapDicts table<string, ApiMapRhsOptsDict>
---@alias KeyMapDict table<string, KeyMapRhsOptsArr>
---@alias KeyMapDicts table<string, KeyMapRhsOptsDict>

---@class ApiMapTbl
---@field lhs string
---@field rhs string
---@field opts? ApiMapOpts

---@class MapTbl: ApiMapTbl

---@class KeyMapTbl: ApiMapTbl
---@field rhs string|fun()
---@field opts? KeyMapOpts

--- The same as `ApiMapTbl`, just add `bufnr` as field.
---@class BufMapTbl: ApiMapTbl
---@field bufnr? integer

---@alias ApiMapFunction fun(lhs: string, rhs: string, opts: ApiMapOpts?)
---@alias KeyMapFunction fun(lhs: string, rhs: string|fun(), opts: KeyMapOpts?)
---@alias BufMapFunction fun(b: integer, lhs: string, rhs: string, opts: ApiMapOpts?)

---@class ApiMapModeDicts
---@field n? ApiMapTbl[]
---@field i? ApiMapTbl[]
---@field v? ApiMapTbl[]
---@field t? ApiMapTbl[]
---@field o? ApiMapTbl[]
---@field x? ApiMapTbl[]

---@class KeyMapModeDicts
---@field n? KeyMapTbl[]
---@field i? KeyMapTbl[]
---@field v? KeyMapTbl[]
---@field t? KeyMapTbl[]
---@field o? KeyMapTbl[]
---@field x? KeyMapTbl[]

---@class BufMapModeDicts: ApiMapModeDicts
---@field n? BufMapTbl[]
---@field i? BufMapTbl[]
---@field v? BufMapTbl[]
---@field t? BufMapTbl[]
---@field o? BufMapTbl[]
---@field x? BufMapTbl[]

---@class UserApiMaps
---@field n ApiMapFunction
---@field v ApiMapFunction
---@field t ApiMapFunction
---@field i ApiMapFunction
---@field o ApiMapFunction
---@field x ApiMapFunction

---@class UserKeyMaps: UserApiMaps
---@field n KeyMapFunction
---@field v KeyMapFunction
---@field t KeyMapFunction
---@field i KeyMapFunction
---@field o KeyMapFunction
---@field x KeyMapFunction

---@class UserBufMaps: UserApiMaps

---@class UserMaps
---@field kmap UserKeyMaps
---@field map UserApiMaps
---@field buf_map UserBufMaps
