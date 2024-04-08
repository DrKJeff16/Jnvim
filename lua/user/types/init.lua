---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user')

---@class CheckerOpts
---@field type? 'union'|'intersection'
---@field recursive? boolean
---@field callback? fun(...)
---@field fail? boolean|fun(...): boolean
---@field case_sensitive? boolean
---@field dir? string|string[]|nil
---@field essential? boolean|fun(...): boolean

---@class CheckerOptsExtended: CheckerOpts

---@alias ChkModFun fun(mod: string|string[]|table, opts: CheckerOpts?): boolean|boolean[]|table<string, boolean>

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
---@field dry_run? fun(f: fun(), ...): any
---@field new? fun(): UserCheck
---@field __index? UserCheck

---@class UserPlugTmpl

---@class UserCmp: UserPlugTmpl
---@class UserNotify: UserPlugTmpl

---@class UserPlugin
---@field cmp? UserCmp
---@field notify? UserNotify

---@class UserTypes
---@field cmp table
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

---@class UserMod
---@field exists fun(mod: string): boolean
---@field check? UserCheck
---@field assoc fun()
---@field maps UserMaps
---@field highlight UserHl
---@field opts fun()
---@field types UserTypes

---@type UserTypes
local M = {}
M.cmp = require('user.types.cmp')
M.comment = require('user.types.comment')
M.colorschemes = require('user.types.colorschemes')
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
