---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.autocmd')

---@alias VimNotifyLvl
---|0
---|1
---|2
---|3
---|4
---|5

---@alias NotifyLvl
---|'debug'
---|'error'
---|'info'
---|'off'
---|'trace'
---|'warn'

---@class NotifyOpts
---@field title? string Defaults to `'Message'`
---@field icon? string
---@field timeout? number|boolean Defaults to `1500`
---@field on_open? fun(...)
---@field on_close? fun(...)
---@field keep? fun(...)
---@field render? string|fun(...)
---@field replace? integer
---@field hide_from_history? boolean Defaults to `false`
---@field animate? boolean Defaults to `true`

---@class User.Util.Notify
---@field notify fun(msg: string, lvl: NotifyLvl|VimNotifyLvl?, opts: NotifyOpts?)

---@class User.Util.Autocmd
---@field au_pair fun(T: AuPair)
---@field au_repeated fun(T: AuRepeat)
---@field au_from_arr fun(T: AuList)
---@field au_from_dict fun(T: AuDict)
---@field au_repeated_events fun(T: AuRepeatEvents)

---@class User.Util
---@field xor fun(x: boolean, y: boolean): boolean
---@field strip_fields fun(T: table, values: string|string[]): table
---@field strip_values fun(T: table, values: any[], max_instances: integer?): table
---@field ft_set fun(s: string, bufnr: integer?): fun()
---@field ft_get fun(bufnr: integer?): string
---@field notify User.Util.Notify
---@field au User.Util.Autocmd
---@field assoc fun()
---@field displace_letter fun(c: string, direction: ('next'|'prev')?, cycle: boolean?): string

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
