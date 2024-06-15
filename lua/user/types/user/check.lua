---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias Types ('nil'|'string'|'number'|'function'|'boolean'|'table')
---@alias ValueFunc fun(var: any, multiple: boolean?): boolean

---@class ExistanceCheck
---@field module fun(mod: string, return_mod: boolean?): boolean|unknown|nil
---@field modules fun(mod: string|string[], need_all: boolean?): boolean|table<string, boolean>
---@field executable fun(exe: string|string[], fallback: fun()?): boolean
---@field env_vars fun(vars: string|string[], fallback: fun()?): boolean
---@field vim_exists fun(expr: string|string[]): boolean
---@field vim_has fun(expr: string|string[]): boolean
---@field vim_isdir fun(path: string): boolean

---@class ValueCheck
--- Checks whether a value is `nil`, i.e. non existant or explicitly set as nil.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's nil.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as non-existant and the function will return `true`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element doesn't exist or is `nil`, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is `nil` or doesn't exist.
--- ---
---@field is_nil ValueFunc
--- Checks whether a value is a string.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a string.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-string and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a string, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a string or not.
--- ---
---@field is_str ValueFunc
--- Checks whether a value is a table.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a table.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-table and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a table, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a table or not.
--- ---
---@field is_tbl ValueFunc
--- Checks whether a value is a number.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a number.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-number and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a number, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a number or not.
--- ---
---@field is_num ValueFunc
--- Checks whether a value is a function.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a function.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-function and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a function, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a function or not.
--- ---
---@field is_fun ValueFunc
--- Checks whether a value is a boolean.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a boolean.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-boolean and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a boolean, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a boolean or not.
--- ---
---@field is_bool ValueFunc
--- Checks whether a value is an integer i.e. _greater than or equal to `0` and a **whole number**_.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's an integer.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-integer and the function will return `false`.
---
--- * `multiple`: Tell the integer you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not an integer, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is an integer or not.
--- ---
---@field is_int fun(var: number|number[], multiple: boolean?): boolean
---@field empty fun(v: string|table|number): boolean
---@field fields fun(fields: string|integer|(string|integer)[], T: table<string|integer, any>): boolean
---@field tbl_values fun(values: any[], T: table, return_keys: boolean?): boolean|string|integer|(string|integer)[]
---@field single_type_tbl fun(type_str: string, T: table): boolean

---@class UserCheck
---@field exists ExistanceCheck
---@field value ValueCheck
---@field in_console fun(): boolean
---@field new? fun(): UserCheck
---@field __index? UserCheck
