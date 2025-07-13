---@meta

error('(user_api.types.autocmd): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@alias AuOpts vim.api.keyset.create_autocmd
---@alias AuGroupOpts vim.api.keyset.create_augroup

---@class AuPair
---@field event string[]|string
---@field opts AuOpts

---@class AuRepeatEvents
---@field events string[]
---@field opts_tbl AuOpts[]

---@alias AuDict table<string, AuOpts>
---@alias AuRepeat table<string, AuOpts[]>
---@alias AuList AuPair[]

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
