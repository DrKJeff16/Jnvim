---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class UserPlugTmpl

---@class UserCmp: UserPlugTmpl
---@class UserNotify: UserPlugTmpl

---@class UserPlugin
---@field cmp? UserCmp
---@field notify? UserNotify

---@class UserTypes
---@field autopairs table
---@field cmp table
---@field colorizer table
---@field colorschemes table
---@field comment table
---@field gitsigns table
---@field lazy table
---@field lspconfig table
---@field lualine table
---@field notify table
---@field nvim_tree table
---@field telescope table
---@field todo_comments table
---@field treesitter table
---@field user UserSubTypes
---@field which_key table

---@class UserOpts

---@class UserMod
---@field check UserCheck
---@field assoc fun()
---@field maps UserMaps
---@field highlight UserHl
---@field opts UserOpts
---@field types UserTypes

---@type UserTypes
local M = {}
M.autopairs = require('user.types.autopairs')
M.colorizer = require('user.types.colorizer')
M.colorschemes = require('user.types.colorschemes')
M.cmp = require('user.types.cmp')
M.comment = require('user.types.comment')
M.gitsigns = require('user.types.gitsigns')
M.lazy = require('user.types.lazy')
M.lspconfig = require('user.types.lspconfig')
M.lualine = require('user.types.lualine')
M.notify = require('user.types.notify')
M.nvim_tree = require('user.types.nvim_tree')
M.telescope = require('user.types.telescope')
M.todo_comments = require('user.types.todo_comments')
M.treesitter = require('user.types.treesitter')
M.which_key = require('user.types.which_key')

M.user = require('user.types.user')

return M
