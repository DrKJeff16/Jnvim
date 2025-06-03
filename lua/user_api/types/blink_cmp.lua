---@meta
---@module 'blink.cmp'

---@alias BlinkCmp.Util.Sources ('lsp'|'path'|'snippets'|'buffer'|string)[]
---@alias BlinkCmp.Util.Providers table<string, blink.cmp.SourceProviderConfigPartial>

---@class BlinkCmp.Util
---@field curr_ft string
---@field sources BlinkCmp.Util.Sources
---@field reset_sources fun(self: BlinkCmp.Util.Sources)
---@field get_sources fun(self: BlinkCmp.Util): BlinkCmp.Util.Sources
---@field Providers BlinkCmp.Util.Providers

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
