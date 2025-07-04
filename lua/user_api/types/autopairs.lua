---@meta

error('(user_api.types.autopairs): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@class APCmp
---@field on fun()

---@class APMods
---@field cmp? fun(): APCmp|nil
---@field rules? fun(): unknown|nil

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
