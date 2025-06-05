---@meta

---@module 'blink.cmp'

---@alias BlinkCmp.Util.Sources ('lsp'|'path'|'snippets'|'buffer'|string)[]
---@alias BlinkCmp.Util.Providers table<string, blink.cmp.SourceProviderConfigPartial>

---@class BlinkCmp.Util
---@field curr_ft string
---@field Sources BlinkCmp.Util.Sources
---@field Providers BlinkCmp.Util.Providers
---@field reset_sources fun(self: BlinkCmp.Util.Sources)
---@field reset_providers fun(self: BlinkCmp.Util.Sources)
---@field gen_sources fun(self: BlinkCmp.Util): BlinkCmp.Util.Sources
---@field gen_providers fun(self: BlinkCmp.Util, P: blink.cmp.SourceProviderConfigPartial?): BlinkCmp.Util.Sources
---@field new fun(O: table?): BlinkCmp.Util|table

---@alias BlinkCmp.Cfg.Config blink.cmp.Config

---@class BlinkCmp.Cfg
---@field config BlinkCmp.Cfg.Config
---@field new fun(O: table?): BlinkCmp.Cfg|table

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
