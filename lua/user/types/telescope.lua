---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')
require('user.types.user.autocmd')

---@class KeyMapArgs
---@field lhs string
---@field rhs string|fun(): any
---@field opts? KeyMapOpts

---@class KeyMapModeDict
---@field n KeyMapArgs[]

---@alias TelAuData table<'title'|'filetype'|'bufname', string>

---@class TelAuArgs
---@field data? TelAuData

---@class TelExtension
---@field [1] string
---@field keys? fun(...): KeyMapArgs[]
