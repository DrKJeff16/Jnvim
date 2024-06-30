---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias AuOpts vim.api.keyset.create_autocmd
---@alias AuGroupOpts vim.api.keyset.create_augroup

---@class AuPair
---@field event string|string[]
---@field opts AuOpts

---@class AuRepeatEvents
---@field events string[]
---@field opts_tbl AuOpts[]

---@alias AuDict table<string, AuOpts>
---@alias AuRepeat table<string, AuOpts[]>
---@alias AuList AuPair[]

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
