---@meta

---@module 'user_api.types.user.maps'
---@module 'user_api.types.user.autocmd'

---@class TelCC.Opts
---@field theme? 'ivy'|'dropdown'|'cursor'
---@field action? fun(entry: table)
---@field include_body_and_footer? boolean

---@class TelCC
---@field cc TelCC.Opts
---@field loadkeys fun()

---@class KeyMapArgs
---@field lhs string
---@field rhs string|fun()
---@field opts? User.Maps.Keymap.Opts

---@class TelAuData
---@field title string
---@field filetype string
---@field bufname string

---@class TelAuArgs
---@field data? TelAuData

---@class TelExtension
---@field [1] string
---@field keys? fun(): (table|KeyMapDict)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
