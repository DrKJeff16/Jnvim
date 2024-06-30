---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')
require('user.types.user.autocmd')

---@class KeyMapArgs
---@field lhs string
---@field rhs string|fun()
---@field opts? KeyMapOpts

---@alias TelAuData table<'title'|'filetype'|'bufname', string>

---@class TelAuArgs
---@field data? TelAuData

---@class TelExtension
---@field [1] string
---@field keys? fun(...): KeyMapDict

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
