---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias ModTbl
---|string[]
---|{ [string]: string }
---|table<string, boolean>

---@class CheckerOpts

---@class CheckerOptsExtended: CheckerOpts

---@class VimExistance
---@field global fun(g: string|string[]): boolean
---@field global_opt fun(field: string|string[], tbl: table?): boolean
---@field buf_opt fun(field: string|string[], bufnr: integer?): boolean
---@field api_field fun(field: string|string[]): boolean

---@class ExistanceCheck
---@field module fun(mod: string): boolean
---@field data fun(v: any|unknown): boolean
---@field field fun(field: string, t: table|table[]): boolean
---@field vim VimExistance

---@class ValueCheck
---@field empty fun(v: string|table|number): boolean
---@field lt fun(v: string|table|number, opts: CheckerOpts?): boolean
---@field gt fun(v: string|table|number, opts: CheckerOpts?): boolean
---@field eq fun(v: string|table|number, opts: CheckerOptsExtended?): boolean
---@field has_val fun(t: table, opts: CheckerOptsExtended): boolean

---@class UserCheck
---@field exists ExistanceCheck
---@field value ValueCheck
---@field dry_run fun(f: fun(), ...): any

---@class UserMod
---@field exists fun(mod: string): boolean
---@field assoc fun()
---@field maps UserMaps
---@field highlight UserHl
---@field opts fun(): any|unknown

---@class UserSubTypes
---@field maps table
---@field highlight table
---@field autocmd table
---@field opts table

---@class UserTypes
---@field lspconfig table
---@field lazy table
---@field cmp table
---@field gitsigns table
---@field colorschemes table
---@field treesitter table
---@field nvim_tree table
---@field todo_comments table
---@field which_key table
---@field user UserSubTypes

---@type UserTypes
local M = {}
M.colorschemes = require('user.types.colorschemes')
M.lazy = require('user.types.lazy')
M.which_key = require('user.types.which_key')
-- M.nvim_tree = require('user.types.nvim_tree')
-- M.todo_comments = require('user.types.todo_comments')
-- M.gitsigns = require('user.types.gitsigns')
-- M.treesitter = require('user.types.treesitter')
-- M.cmp = require('user.types.cmp')
M.user = {}
M.user.maps = require('user.types.user.maps')
M.user.opts = require('user.types.user.opts')
M.user.autocmd = require('user.types.user.autocmd')
M.user.highlight = require('user.types.user.highlight')

return M
