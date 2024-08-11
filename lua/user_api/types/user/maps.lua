require('user_api.types.which_key')

---@alias User.Maps.Api.Opts vim.api.keyset.keymap
---@alias User.Maps.Keymap.Opts vim.keymap.set.Opts

--- `Rhs` for use in `vim.keymap.set`
---@alias User.Maps.Keymap.Rhs string|fun()

--- `Rhs` for use in `vim.api.nvim_set_keymap`
---@alias User.Maps.Api.Rhs string

--- Available modes
---@alias MapModes ('n'|'i'|'v'|'t'|'o'|'x')

--- Array for available modes
---@alias Modes MapModes[]

---@class ApiMapRhsOptsArr
---@field [1] User.Maps.Api.Rhs
---@field [2]? User.Maps.Api.Opts

---@class KeyMapRhsOptsArr
---@field [1] User.Maps.Keymap.Rhs
---@field [2]? User.Maps.Keymap.Opts

---@class ApiMapRhsOptsDict
---@field rhs User.Maps.Api.Rhs
---@field opts? User.Maps.Api.Opts

---@class KeyMapRhsOptsDict
---@field rhs User.Maps.Keymap.Rhs
---@field opts? User.Maps.Keymap.Opts

--- Array for `vim.api.nvim_set_keymap` arguments
---@class ApiMapArr
---@field [1] string
---@field [2] string
---@field [3]? User.Maps.Api.Opts

--- Array for `vim.keymap.set` arguments
---@class KeyMapArr
---@field [1] string
---@field [2] string|fun()
---@field [3]? User.Maps.Keymap.Opts

---@alias ApiMapDict table<string, ApiMapRhsOptsArr>
---@alias ApiMapDicts table<string, ApiMapRhsOptsDict>
---@alias KeyMapDict table<string, KeyMapRhsOptsArr>
---@alias KeyMapDicts table<string, KeyMapRhsOptsDict>

---@class ApiMapTbl
---@field lhs string
---@field rhs string
---@field opts? User.Maps.Api.Opts

---@class KeyMapTbl
---@field lhs string
---@field rhs string|fun()
---@field opts? User.Maps.Keymap.Opts

--- The same as `ApiMapTbl`, just add `bufnr` as field
---@class BufMapTbl: ApiMapTbl
---@field bufnr integer

---@alias ApiMapFunction fun(lhs: string, rhs: User.Maps.Api.Rhs, opts: User.Maps.Api.Opts?)
---@alias KeyMapFunction fun(lhs: string, rhs: User.Maps.Keymap.Rhs, opts: User.Maps.Keymap.Opts?)
---@alias BufMapFunction fun(b: integer, lhs: string, rhs: User.Maps.Api.Rhs, opts: User.Maps.Api.Opts?)

---@alias ApiMapModeDicts table<MapModes, ApiMapTbl[]>
---@alias KeyMapModeDicts table<MapModes, KeyMapTbl[]>
---@alias BufMapModeDicts table<MapModes, BufMapTbl[]>

---@alias ApiMapModeDict table<MapModes, ApiMapDict>
---@alias KeyMapModeDict table<MapModes, KeyMapDict>
---@alias BufMapModeDict table<MapModes, ApiMapDict>

---@alias MapFuncs ApiMapFunction|KeyMapFunction|BufMapFunction

---@alias ApiDescFun fun(msg: string, silent: boolean?, noremap: boolean?, nowait: boolean?, expr: boolean?): User.Maps.Api.Opts
---@alias BufDescFun ApiDescFun
---@alias KeyDescFun fun(msg: string, silent: boolean?, bufnr: integer?, noremap: boolean?, nowait: boolean?, expr: boolean?): User.Maps.Keymap.Opts|table

---@class User.Maps.Api
---@field n ApiMapFunction
---@field i ApiMapFunction
---@field v ApiMapFunction
---@field t ApiMapFunction
---@field o ApiMapFunction
---@field x ApiMapFunction
---@field desc ApiDescFun

---@class User.Maps.Keymap
---@field n KeyMapFunction
---@field i KeyMapFunction
---@field v KeyMapFunction
---@field t KeyMapFunction
---@field o KeyMapFunction
---@field x KeyMapFunction
---@field desc KeyDescFun

---@class User.Maps.Buf
---@field n BufMapFunction
---@field i BufMapFunction
---@field v BufMapFunction
---@field t BufMapFunction
---@field o BufMapFunction
---@field x BufMapFunction
---@field desc BufDescFun

---@class User.Maps.WK
---@field available fun(): boolean
---@field convert fun(lhs: string, rhs: User.Maps.Keymap.Rhs|User.Maps.Api.Rhs|RegKey|RegPfx, opts: (User.Maps.Api.Opts|User.Maps.Keymap.Opts|RegKeyOpts)?): RegKey|RegPfx
---@field convert_dict fun(T: KeyMapDict|ApiMapDict|RegKeys|RegKeysNamed): RegKeys|RegKeysNamed
---@field register fun(T: RegKeys|RegKeysNamed, opts: RegOpts?): false?

---@class User.Maps
---@field kmap User.Maps.Keymap
---@field map User.Maps.Api
---@field buf_map User.Maps.Buf
---@field nop fun(T: string|string[], opts: User.Maps.Keymap.Opts?, mode: MapModes?, prefix: string?)
---@field wk User.Maps.WK
---@field modes Modes
---@field map_dict fun(T: KeyMapModeDict|KeyMapDict|RegKeysNamed|RegKeys, map_func: 'wk.register'|'kmap'|'map', dict_has_modes: boolean?, mode: (MapModes|nil)?, bufnr: (integer|nil)?)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
