---@meta

error('(user_api.types.user.highlight): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@alias HlOpts vim.api.keyset.highlight

---@class HlPair
---@field name string
---@field opts HlOpts

---@alias HlDict table<string, HlOpts>

---@alias HlPairs HlPair[]
---@alias HlDicts HlDict[]

---@class User.Hl
---@field hl fun(name: string, opts: HlOpts, bufnr: integer?)
---@field hl_from_arr fun(A: HlPairs)
---@field hl_from_dict fun(D: HlDict)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
