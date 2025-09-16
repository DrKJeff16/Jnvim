---@class HlPair
---@field name string
---@field opts vim.api.keyset.highlight

---@alias HlDict table<string, vim.api.keyset.highlight>

local ERROR = vim.log.levels.ERROR

---A set of utilities to make Vim highlighting easier.
--- ---
---@class User.Hl
local Hl = {}

---@param name string The highlight group
---@param opts vim.api.keyset.highlight The highlight options
---@param ns? integer The highlighting namespace **(OPTIONAL)**
function Hl.hl(name, opts, ns)
    local Value = require('user_api.check.value')

    local type_not_empty = Value.type_not_empty

    if not (type_not_empty('string', name) and type_not_empty('table', opts)) then
        vim.notify('(user_api.highlight.hl): Bad argument', ERROR)
        return
    end

    vim.api.nvim_set_hl(ns or 0, name, opts)
end

---Set highlight groups based on an array of `HlPair` type highlight groups.
--- ---
---Example of a valid `HlPair` array:
---```lua
------@type HlPair[]
---local T = {
---  { name = 'HlGroup', opts = { fg = '...', ... } } ,
---  { name = 'HlGroupAlt', opts = { link = 'Normal' },
---  --- ...
---}
---```
---See more at `:h nvim_set_hl`.
--- ---
---@param A HlPair[] The array of `HlPair` objects
function Hl.hl_from_arr(A)
    local Value = require('user_api.check.value')

    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', A) then
        error('(user_api.highlight.hl_from_arr): Bad argument', ERROR)
    end

    for _, t in ipairs(A) do
        if type_not_empty('string', t.name) and type_not_empty('table', t.opts) then
            Hl.hl(t.name, t.opts)
        else
            vim.notify('(user_api.highlight.hl_from_arr): Skipping invalid table', ERROR)
        end
    end
end

---Set highlight groups using a `HlDict` type table.
--- ---
---Example of a valid `HlDict` table:
---```lua
------@type HlDict
---local T = {
---  ['HlGroup'] = { fg = '...' },
---  ['HlGroupAlt'] = { link = 'Normal' },
---}
---```
---To know what options are valid try `:h nvim_set_hl`.
--- ---
---@param D HlDict
function Hl.hl_from_dict(D)
    local Value = require('user_api.check.value')

    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', D) then
        vim.notify('(user_api.highlight.hl_from_dict): Unable to parse argument', ERROR)
        return
    end

    for k, v in pairs(D) do
        if type_not_empty('string', k) and type_not_empty('table', v) then
            Hl.hl(k, v)
        else
            vim.notify('(user_api.highlight.hl_from_dict): Skipping bad highlight', ERROR)
        end
    end
end

---@return table|User.Hl
function Hl.new()
    return setmetatable({}, {
        __index = Hl,
        __newindex = function(_, _, _)
            error('(user_api.highlight): This is an immutable module!', ERROR)
        end,
    })
end

return Hl.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
