---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user_api.types.user.maps')
require('user_api.types.user.autocmd')

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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
