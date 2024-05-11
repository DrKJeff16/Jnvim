---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias HlOpts vim.api.keyset.highlight

---@class HlPair
---@field name string
---@field opts HlOpts

---@alias HlDict table<string, HlOpts>

---@alias HlPairs HlPair[]
---@alias HlDicts HlDict[]

---@class UserHl
---@field hl fun(name: string, opts: HlOpts, bufnr: integer?)
---@field hl_from_arr fun(arr: HlPairs)
---@field hl_from_dict fun(dict: HlDict)
---@field current_palette fun()
