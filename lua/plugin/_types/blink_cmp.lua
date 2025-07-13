---@meta

error('(plugin._types.blink_cmp): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@module 'blink.cmp'

---@alias BlinkCmp.Util.Sources ('lsp'|'path'|'snippets'|'buffer'|string)[]
---@alias BlinkCmp.Util.Providers table<string, blink.cmp.SourceProviderConfigPartial>

---@class BlinkCmp.Util
---@field curr_ft string
---@field Sources BlinkCmp.Util.Sources
---@field Providers BlinkCmp.Util.Providers
---@field reset_sources fun(self: BlinkCmp.Util, snipps: boolean?, buf: boolean?)
---@field reset_providers fun(self: BlinkCmp.Util)
---@field gen_sources fun(self: BlinkCmp.Util, snipps: boolean?, buf: boolean?): BlinkCmp.Util.Sources
---@field gen_providers fun(self: BlinkCmp.Util, P: BlinkCmp.Util.Providers?): BlinkCmp.Util.Providers
---@field new fun(O: table?): table|BlinkCmp.Util

---@alias BlinkCmp.Cfg.Config blink.cmp.Config

---@class BlinkCmp.Cfg
---@field Config BlinkCmp.Cfg.Config
---@field new fun(O: table?): table|BlinkCmp.Cfg

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
