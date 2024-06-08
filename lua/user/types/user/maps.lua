require('user.types.which_key')

---@alias UserMaps.Api.Opts vim.api.keyset.keymap
---@alias UserMaps.Keymap.Opts vim.keymap.set.Opts
---@alias UserMaps.Buf.Opts UserMaps.Api.Opts

--- `Rhs` for use in `vim.keymap.set`
---@alias UserMaps.Keymap.Rhs string|fun()

--- `Rhs` for use in `vim.api.nvim_set_keymap`
---@alias UserMaps.Api.Rhs string

--- Available modes
---@alias MapModes ('n'|'i'|'v'|'t'|'o'|'x')

--- Array for available modes
---@alias Modes MapModes[]

---@class ApiMapRhsOptsArr
---@field [1] UserMaps.Api.Rhs
---@field [2]? UserMaps.Api.Opts

---@class KeyMapRhsOptsArr
---@field [1] UserMaps.Keymap.Rhs
---@field [2]? UserMaps.Keymap.Opts

---@class ApiMapRhsOptsDict
---@field rhs UserMaps.Api.Rhs
---@field opts? UserMaps.Api.Opts

---@class KeyMapRhsOptsDict
---@field rhs UserMaps.Keymap.Rhs
---@field opts? UserMaps.Keymap.Opts

--- Array for `vim.api.nvim_set_keymap` arguments
---@class ApiMapArr
---@field [1] string
---@field [2] string
---@field [3]? UserMaps.Api.Opts

---@class BufMapArr: ApiMapArr

--- Array for `vim.keymap.set` arguments
---@class KeyMapArr: ApiMapArr
---@field [1] string
---@field [2] string|fun()
---@field [3]? UserMaps.Keymap.Opts

---@alias ApiMapDict table<string, ApiMapRhsOptsArr>
---@alias ApiMapDicts table<string, ApiMapRhsOptsDict>
---@alias KeyMapDict table<string, KeyMapRhsOptsArr>
---@alias KeyMapDicts table<string, KeyMapRhsOptsDict>

---@class ApiMapTbl
---@field lhs string
---@field rhs string
---@field opts? UserMaps.Api.Opts

---@class MapTbl: ApiMapTbl

---@class KeyMapTbl: ApiMapTbl
---@field rhs string|fun()
---@field opts? UserMaps.Keymap.Opts

--- The same as `ApiMapTbl`, just add `bufnr` as field.
---@class BufMapTbl: ApiMapTbl
---@field bufnr integer

---@alias ApiMapFunction fun(lhs: string, rhs: string, opts: UserMaps.Api.Opts?)
---@alias KeyMapFunction fun(lhs: string, rhs: string|fun(), opts: UserMaps.Keymap.Opts?)
---@alias BufMapFunction fun(b: integer, lhs: string, rhs: string, opts: UserMaps.Api.Opts?)

---@alias ApiMapModeDicts table<MapModes, ApiMapTbl[]>
---@alias KeyMapModeDicts table<MapModes, KeyMapTbl[]>
---@alias BufMapModeDicts table<MapModes, BufMapTbl[]>

---@alias ApiMapModeDict table<MapModes, ApiMapDict>
---@alias KeyMapModeDict table<MapModes, KeyMapDict>
---@alias BufMapModeDict table<MapModes, ApiMapDict>

---@alias MapFuncs
---|fun(mode: string, lhs: string|string[], rhs: string|fun(), opts:(UserMaps.Api.Opts|UserMaps.Keymap.Opts)?)
---|fun(bufnr: integer, mode: string, lhs: string|string[], rhs: string, opts: UserMaps.Buf.Opts?)

---@alias ApiDescFun fun(msg: string, silent: boolean?, noremap: boolean?, nowait: boolean?, expr: boolean?): UserMaps.Api.Opts
---@alias BufDescFun fun(msg: string, silent: boolean?, noremap: boolean?, nowait: boolean?, expr: boolean?): UserMaps.Buf.Opts
---@alias KeyDescFun fun(msg: string, silent: boolean?, bufnr: integer?, noremap: boolean?, nowait: boolean?, expr: boolean?): UserMaps.Keymap.Opts

---@class UserMaps.Api
---@field n ApiMapFunction
---@field i ApiMapFunction
---@field v ApiMapFunction
---@field t ApiMapFunction
---@field o ApiMapFunction
---@field x ApiMapFunction
---@field desc ApiDescFun

---@class UserMaps.Keymap
---@field n KeyMapFunction
---@field i KeyMapFunction
---@field v KeyMapFunction
---@field t KeyMapFunction
---@field o KeyMapFunction
---@field x KeyMapFunction
---@field desc KeyDescFun

---@class UserMaps.Buf
---@field n BufMapFunction
---@field i BufMapFunction
---@field v BufMapFunction
---@field t BufMapFunction
---@field o BufMapFunction
---@field x BufMapFunction
---@field desc BufDescFun

---@class UserMaps.WK
---@field available fun(): boolean
---@field convert fun(rhs: UserMaps.Keymap.Rhs, opts: (UserMaps.Api.Opts|UserMaps.Keymap.Opts|UserMaps.Buf.Opts)?): RegKey|'which_key_ignore'
---@field convert_dict fun(T: KeyMapDict|ApiMapDict): RegKeys
---@field register fun(T: RegKeys|RegKeysNamed, opts: RegOpts?): false|nil

---@class UserMaps
---@field kmap UserMaps.Keymap
---@field map UserMaps.Api
---@field buf_map UserMaps.Buf
---@field nop fun(T: string|string[], opts: UserMaps.Keymap.Opts?, mode: MapModes?, prefix: string?)
---@field wk UserMaps.WK
---@field modes Modes
---@field map_dict fun(T: ApiMapModeDict|KeyMapModeDict|ApiMapDict|KeyMapDict, map_func: 'wk.register'|'kmap'|'map', dict_has_modes: boolean?, mode: MapModes?, bufnr: integer|nil?)
