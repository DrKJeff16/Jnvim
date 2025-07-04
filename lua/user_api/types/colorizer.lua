---@meta

error('(user_api.types.colorizer): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@class ColorizerOpts
---@field RGB? boolean
---@field RRGGBB? boolean
---@field RRGGBBAA? boolean
---@field names? boolean
---@field rgb_fn? boolean
---@field hsl_fn boolean
---@field css? boolean
---@field css_fn? boolean
---@field mode? 'foreground'|'background'
---@field new? fun(O: table?): table|ColorizerOpts

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
