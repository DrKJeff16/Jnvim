---@meta

---@module 'user_api.types.which_key'

---@alias User.Maps.Keymap.Opts vim.keymap.set.Opts

--- `Rhs` for use in `vim.keymap.set`
---@alias User.Maps.Keymap.Rhs string|fun()

--- Available modes
---@alias MapModes ('n'|'i'|'v'|'t'|'o'|'x')

--- Array for available modes
---@alias Modes MapModes[]

---@class KeyMapRhsOptsArr
---@field [1] User.Maps.Keymap.Rhs
---@field [2]? User.Maps.Keymap.Opts

---@class KeyMapRhsOptsDict
---@field rhs User.Maps.Keymap.Rhs
---@field opts? User.Maps.Keymap.Opts

--- Array for `vim.keymap.set` arguments
---@class KeyMapArr
---@field [1] string
---@field [2] string|fun()
---@field [3]? User.Maps.Keymap.Opts

---@alias KeyMapDict table<string, KeyMapRhsOptsArr>
---@alias KeyMapDicts table<string, KeyMapRhsOptsDict>

---@alias AllMaps table<string, KeyMapRhsOptsArr|RegKey|RegPfx>
---@alias AllModeMaps table<MapModes, AllMaps>

---@class KeyMapTbl
---@field lhs string
---@field rhs string|fun()
---@field opts? User.Maps.Keymap.Opts

---@class KeyMapOpts: vim.keymap.set.Opts
---@field new fun(T: (User.Maps.Keymap.Opts|table)?): KeyMapOpts
---@field add fun(self: KeyMapOpts, T: User.Maps.Keymap.Opts|table)

---@alias KeyMapFunction fun(lhs: string, rhs: User.Maps.Keymap.Rhs, opts: User.Maps.Keymap.Opts?)

---@alias KeyMapModeDict table<MapModes, KeyMapDict>
---@alias KeyMapModeDicts table<MapModes, KeyMapTbl[]>

---@alias MapFuncs KeyMapFunction

---@alias KeyDescFun fun(msg: string, silent: boolean?, bufnr: integer?, noremap: boolean?, nowait: boolean?, expr: boolean?): User.Maps.Keymap.Opts

---@class User.Maps.Keymap
---@field n KeyMapFunction
---@field i KeyMapFunction
---@field v KeyMapFunction
---@field t KeyMapFunction
---@field o KeyMapFunction
---@field x KeyMapFunction
---@field desc KeyDescFun

---@class User.Maps.WK
---@field available fun(): boolean
---@field convert fun(lhs: string, rhs: User.Maps.Keymap.Rhs|RegKey|RegPfx, opts: (User.Maps.Keymap.Opts|RegKeyOpts)?): RegKey|RegPfx
---@field convert_dict fun(T: KeyMapDict|RegKeys|RegKeysNamed): RegKeys|RegKeysNamed
---@field register fun(T: RegKeys|RegKeysNamed, opts: RegOpts?): false?

---@class User.Maps
---@field kmap User.Maps.Keymap
---@field nop fun(T: string|string[], opts: User.Maps.Keymap.Opts?, mode: MapModes?, prefix: string?)
---@field wk User.Maps.WK
---@field modes Modes
---@field map_dict fun(T: AllModeMaps|AllMaps, map_func: 'wk.register'|'kmap', dict_has_modes: boolean?, mode: (MapModes|nil)?, bufnr: (integer|nil)?)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
