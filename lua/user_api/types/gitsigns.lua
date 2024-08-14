---@meta

require('user_api.types.user.maps')

---@class GitSignOpts
---@field text string

---@alias GitSigns table<'add'|'change'|'delete'|'topdelete'|'changedelete'|'untracked', GitSignOpts>

---@alias GitSignsArr GitSigns[]

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
