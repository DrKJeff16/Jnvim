local Types = require('user_api.types') ---@see User.Types
local Check = require('user_api.check') ---@see User.Check
local Util = require('user_api.util') ---@see User.Util

---@type User
---@diagnostic disable-next-line:missing-fields
local M = {
    types = require('user_api.types'),
    util = require('user_api.util'),
    check = require('user_api.check'),
    maps = require('user_api.maps'),
    highlight = require('user_api.highlight'),
    opts = require('user_api.opts'),
    distro = require('user_api.distro'),
    update = require('user_api.update'),
    commands = require('user_api.commands'):new(),
}

M.registered_plugins = {}

---@param pathstr string
---@param i? integer
function M.register_plugin(pathstr, i)
    local is_nil = M.check.value.is_nil
    local is_str = M.check.value.is_str
    local empty = M.check.value.empty
    local notify = M.util.notify.notify

    i = (M.check.value.is_int(i) and i >= 1) and i or 0
    if not is_str(pathstr) or empty(pathstr) then
        error('(user_api.register_plugin): Plugin must be a non-empty string')
    end

    if vim.tbl_contains(M.registered_plugins, pathstr) then
        return
    end

    ---@type nil|string
    local warning = nil

    if i >= 1 and i <= #M.registered_plugins then
        table.insert(M.registered_plugins, i, pathstr)
    elseif i < 0 or i > #M.registered_plugins then
        warning = '(user_api.register_plugin): Invalid index, appending instead'
    else
        table.insert(M.registered_plugins, pathstr)
    end

    if not is_nil(warning) then
        notify(warning, 'warn', {
            hide_from_history = false,
            timeout = 350,
            title = 'User API',
        })
    end
end

---@param self User
---@return string[]|nil failed
function M:reload_plugins()
    ---@type table|string[]
    local failed = {}
    for _, plugin in next, self.registered_plugins do
        if not self.check.exists.module(plugin) then
            table.insert(failed, plugin)
        end
    end

    if not vim.tbl_isempty(failed) then
        return failed
    end

    return nil
end

---@param self User
function M:print_loaded_plugins()
    local notify = self.util.notify.notify

    local msg = '{'

    for _, P in next, self.registered_plugins do
        msg = msg .. string.char(10) .. '  ' .. P
    end

    msg = msg .. string.char(10) .. '}'

    notify(msg)
end

---@param o? table
---@return User|table self
function M.new(o)
    o = M.check.value.is_tbl(o) and o or {}
    local self = setmetatable(o, { __index = M })

    return self
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
