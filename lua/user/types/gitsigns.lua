---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.maps')

---@class GitSignOpts
---@field text string

---@class GitSigns
---@field add GitSignOpts
---@field change GitSignOpts
---@field delete GitSignOpts
---@field topdelete GitSignOpts
---@field changedelete GitSignOpts
---@field untracked GitSignOpts

---@alias GitSignsArr GitSigns[]
