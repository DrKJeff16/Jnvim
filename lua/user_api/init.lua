local Types = require('user_api.types') ---@see User.Types
local Check = require('user_api.check') ---@see User.Check
local Util = require('user_api.util') ---@see User.Util

---@type User
---@diagnostic disable-next-line:missing-fields
local M = {}

M.types = require('user_api.types')

M.util = require('user_api.util')

M.check = require('user_api.check')

M.maps = require('user_api.maps')

M.highlight = require('user_api.highlight')

M.opts = require('user_api.opts')

M.distro = require('user_api.distro')

M.update = require('user_api.update')

M.commands = require('user_api.commands'):new()

M.registered_plugins = {}

---@param self? User
---@param pathstr string
---@param i? integer
function M:register_plugin(pathstr, i)
    local Value = self.check.value

    local is_nil = Value.is_nil
    local is_str = Value.is_str
    local is_int = Value.is_int
    local empty = Value.empty
    local notify = self.util.notify.notify

    i = (is_int(i) and i >= 1) and i or 0
    if not is_str(pathstr) or empty(pathstr) then
        error('(user_api.register_plugin): Plugin must be a non-empty string')
    end

    if vim.tbl_contains(self.registered_plugins, pathstr) then
        return
    end

    ---@type nil|string
    local warning = nil

    if i >= 1 and i <= #self.registered_plugins then
        table.insert(self.registered_plugins, i, pathstr)
    elseif i < 0 or i > #self.registered_plugins then
        warning = 'Invalid index, appending instead'
    elseif i == 0 then
        table.insert(self.registered_plugins, pathstr)
    end

    if not is_nil(warning) then
        notify(warning, 'warn', {
            hide_from_history = false,
            animate = false,
            timeout = 1750,
            title = '(user_api.register_plugin)',
        })
    end
end

function M:setup_keys()
    local wk_avail = self.maps.wk.available
    local desc = self.maps.kmap.desc
    local map_dict = self.maps.map_dict
    local is_nil = self.check.value.is_nil

    if wk_avail() then
        map_dict({
            ['<leader>U'] = { group = '+User API' },
            ['<leader>UP'] = { group = '+Plugins' },
        }, 'wk.register', false, 'n')
    end
    map_dict({
        ['<leader>UPr'] = {
            function()
                local notify = self.util.notify.notify
                notify('Reloading...', 'info', {
                    hide_from_history = true,
                    title = 'User API',
                    timeout = 400,
                })
                local res = self:reload_plugins()

                if not is_nil(res) then
                    notify((inspect or vim.inspect)(res), 'error', {
                        hide_from_history = false,
                        timeout = 1000,
                        title = 'User API [ERROR]',
                        animate = true,
                    })
                else
                    notify('Success!', 'info', {
                        hide_from_history = true,
                        timeout = 200,
                        title = 'User API',
                    })
                end
            end,
            desc('Reload All Plugins'),
        },
        ['<leader>UPl'] = {
            function() self:print_loaded_plugins() end,
            desc('Print Loaded Plugins'),
        },
    }, 'wk.register', false, 'n')
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
    local nwl = newline or string.char(10)

    local msg = ''

    for _, P in next, self.registered_plugins do
        msg = msg .. '- ' .. P .. nwl
    end

    notify(msg, 'info', {
        hide_from_history = false,
        animate = false,
        timeout = 1750,
        title = 'User API',
    })
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
