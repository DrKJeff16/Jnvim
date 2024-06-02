---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias VimNotifyLvl
---|0
---|1
---|2
---|3
---|4
---|5

---@alias NotifyLvl NotifyLevel

---@class NotifyOpts
---@field title? string Defaults to `'Message'`
---@field icon? string
---@field timeout? number|boolean Defaults to `1500`
---@field on_open? fun(...)
---@field on_close? fun(...)
---@field keep? fun(...)
---@field render? string|fun(...)
---@field replace? integer|notify.Record
---@field hide_from_history? boolean Defaults to `false`
---@field animate? boolean Defaults to `true`

---@class UserUtils.Notify
---@field notify fun(msg: string, lvl: NotifyLvl|VimNotifyLvl?, opts: NotifyOpts?)

---@class UserUtils
---@field strip_fields fun(T: table, fields: string|string[]): table
---@field ft_set fun(s: string, bufnr: integer?): fun()
---@field ft_get fun(bufnr: integer?): string
---@field notify UserUtils.Notify
