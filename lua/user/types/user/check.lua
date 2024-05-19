---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias Types 'nil'|'string'|'number'|'userdata'|'thread'|'function'|'boolean'|'table'
---@alias ValueFunc fun(var: any, multiple: boolean?): boolean

---@class ExistanceCheck
---@field module fun(mod: string, return_mod: boolean?): boolean|unknown|nil
---@field modules fun(mod: string|string[], need_all: boolean?): (boolean|table<string, boolean>)
---@field executable fun(exe: string|string[], fallback: fun()?): boolean
---@field field fun(field: string|integer, t: table<string|integer, any>): boolean
---@field vim_exists fun(expr: string|string[]): boolean
---@field vim_has fun(expr: string|string[]): boolean
---@field vim_isdir fun(path: string): boolean

---@class ValueCheck
---@field is_nil ValueFunc
---@field is_str ValueFunc
---@field is_tbl ValueFunc
---@field is_num ValueFunc
---@field is_fun ValueFunc
---@field is_bool ValueFunc
---@field is_int ValueFunc
---@field empty fun(v: string|table|number): boolean

---@class UserCheck
---@field exists ExistanceCheck
---@field value ValueCheck
---@field dry_run? fun(f: fun(), ...): unknown|nil
---@field new? fun(): UserCheck
---@field __index? UserCheck
