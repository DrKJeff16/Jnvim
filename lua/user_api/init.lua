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
    registered_plugins = {},
}

---@param pathstr string
function M.register_plugin(pathstr)
    local exists = require('user_api.check.exists').module

    if not M.check.value.is_str(pathstr) or M.check.value.empty(pathstr) then
        error('(User.register_plugin): Invalid path for plugin')
    end

    if not vim.tbl_contains(M.registered_plugins, pathstr) then
        table.insert(M.registered_plugins, pathstr)
    end
end

---@param self User
---@return string[]|nil
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

---@param o? table
---@return User|table self
function M.new(o)
    o = M.check.value.is_tbl(o) and o or {}
    local self = setmetatable(o, { __index = M })

    return self
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
