local Value = require('user_api.check.value')

local type_not_empty = Value.type_not_empty

local validate = vim.validate
local in_tbl = vim.tbl_contains

---@class User.Maps.Opts: vim.keymap.set.Opts
local O = {}

---@param self User.Maps.Opts
---@param T User.Maps.Opts
function O:add(T)
    validate('T', T, 'table', false, 'User.Maps.Opts|table')

    if not type_not_empty('table', T) then
        return
    end

    for k, v in pairs(T) do
        if not in_tbl({ 'add', 'new' }, k) then
            self[k] = v
        end
    end
end

---@param T? User.Maps.Opts
---@return User.Maps.Opts
function O.new(T)
    validate('T', T, 'table', true, 'User.Maps.Opts|table')

    return setmetatable(T or {}, {
        __index = O,
    })
end

return O

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
