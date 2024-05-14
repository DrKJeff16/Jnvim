---@alias ApiMapOpts vim.api.keyset.keymap
---@alias KeyMapOpts vim.keymap.set.Opts
---@alias BufMapOpts ApiMapOpts

--- `Rhs` for use in `vim.keymap.set`
---@alias KeyRhs string|fun()

--- `Rhs` for use in `vim.api.nvim_set_keymap`
---@alias ApiRhs string

--- Available modes
---@alias MapModes 'n'|'i'|'v'|'t'|'o'|'x'

--- Array for available modes
---@alias Modes (MapModes)[]

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

--- Array for `vim.api.nvim_set_keymap` arguments
---@class ApiMapArr
---@field [1] string
---@field [2] string
---@field [3]? ApiMapOpts

---@class BufMapArr: ApiMapArr

--- Array for `vim.keymap.set` arguments
---@class KeyMapArr: ApiMapArr
---@field [1] string
---@field [2] string|fun()
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
---@field bufnr integer

---@alias ApiMapFunction fun(lhs: string, rhs: string, opts: ApiMapOpts?)
---@alias KeyMapFunction fun(lhs: string, rhs: string|fun(), opts: KeyMapOpts?)
---@alias BufMapFunction fun(b: integer, lhs: string, rhs: string, opts: ApiMapOpts?)

---@alias ApiMapModeDicts table<MapModes, ApiMapTbl[]>
---@alias KeyMapModeDicts table<MapModes, KeyMapTbl[]>
---@alias BufMapModeDicts table<MapModes, BufMapTbl[]>

---@alias MapFuncs
---|fun(lhs: string|string[], rhs: string|fun(), opts:(ApiMapOpts|KeyMapOpts)?)
---|fun(bufnr: integer, lhs: string|string[], rhs: string, opts: BufMapOpts?)

---@alias UserApiMaps table<MapModes,ApiMapFunction>
---@alias UserKeyMaps table<MapModes,KeyMapFunction>
---@alias UserBufMaps table<MapModes,BufMapFunction>

---@class UserMaps
---@field kmap UserKeyMaps
---@field map UserApiMaps
---@field buf_map UserBufMaps
---@field nop fun(T: string|string[], opts: ApiMapOpts?, mode: MapModes?)
---@field modes Modes
---@field map_tbl? MapTblFun
