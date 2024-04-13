---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

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
---@field data fun(v: any): boolean
---@field field fun(field: string|integer, t: table<string, any>): boolean
---@field vim VimExistance
---@field executable fun(exe: string|string[], fallback: (nil|fun(): unknown)?): boolean

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
