---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@class ExistanceCheck
---@field module fun(mod: string): boolean
---@field modules? fun(mod: string|string[], need_all: boolean?): (boolean|table<string, boolean>)
---@field executable fun(exe: string|string[], fallback: (nil|fun(): unknown)?): boolean
---@field data fun(v: any): boolean
---@field field fun(field: string|integer, t: table<string, any>): boolean

---@class ValueCheck
---@field empty fun(v: string|table|number): boolean
---@field lt fun(x: (string|table|number)[], y: string|table|number, eq: boolean?): boolean
---@field gt fun(x: (string|table|number)[], y: string|table|number, eq: boolean?): boolean
---@field eq fun(x: (string|table|number)[], y: string|table|number): boolean

---@class UserCheck
---@field exists ExistanceCheck
---@field value ValueCheck
---@field dry_run? fun(f: fun(), ...): any
---@field new? fun(): UserCheck
---@field __index? UserCheck
