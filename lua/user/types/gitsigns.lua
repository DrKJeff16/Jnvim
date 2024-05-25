---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require("user.types.user.maps")

---@class GitSignOpts
---@field text string

---@alias GitSigns table<'add'|'change'|'delete'|'topdelete'|'changedelete'|'untracked', GitSignOpts>

---@alias GitSignsArr GitSigns[]
