---@diagnostic disable:missing-fields

---@module 'user_api.types.user.user'

---@type UserAPI
local User = {}

---@type User.Check
User.check = require('user_api.check')

---@type User.Commands
User.commands = require('user_api.commands')

---@type User.Distro
User.distro = require('user_api.distro')

---@type User.Hl
User.highlight = require('user_api.highlight')

---@type User.Maps
User.maps = require('user_api.maps')

---@type User.Opts
User.opts = require('user_api.opts')

---@type User.Update
User.update = require('user_api.update')

---@type User.Util
User.util = require('user_api.util')

---@type string[]
User.registered_plugins = {}

---@param self UserAPI
---@param pathstr string
---@param index? integer
function User:register_plugin(pathstr, index)
    local Value = self.check.value

    local notify = self.util.notify.notify
    local is_nil = Value.is_nil
    local is_str = Value.is_str
    local is_int = Value.is_int
    local empty = Value.empty
    local tbl_contains = vim.tbl_contains

    index = (is_int(index) and index >= 1 and index <= #self.registered_plugins) and index or 0
    if not is_str(pathstr) or empty(pathstr) then
        error('(user_api:register_plugin): Plugin must be a non-empty string')
    end

    if tbl_contains(self.registered_plugins, pathstr) then
        local old_idx = 0
        for i, v in next, self.registered_plugins do
            if v == pathstr then
                old_idx = i
                break
            end
        end

        table.remove(self.registered_plugins, old_idx)

        if tbl_contains({ 0, old_idx }, index) or index > #self.registered_plugins then
            table.insert(self.registered_plugins, old_idx, pathstr)
        else
            table.insert(self.registered_plugins, index, pathstr)

            notify(
                string.format('Moved `%s` from index `%d` to `%d`', pathstr, old_idx, index),
                'info',
                {
                    title = 'User API - register_plugin()',
                    animate = true,
                    timeout = 1050,
                    hide_from_history = false,
                }
            )
        end

        return
    end

    ---@type string|nil
    local warning = nil

    if index >= 1 and index <= #self.registered_plugins then
        table.insert(self.registered_plugins, index, pathstr)
    elseif index == 0 then
        table.insert(self.registered_plugins, pathstr)
    elseif index < 0 or index > #self.registered_plugins then
        warning = 'Invalid index, appending instead'
        table.insert(self.registered_plugins, pathstr)
    end

    if is_nil(warning) then
        return
    end

    notify(warning, 'warn', {
        hide_from_history = false,
        animate = false,
        timeout = 1000,
        title = '(user_api:register_plugin)',
    })
end

---@param self UserAPI
---@return string[]|nil
function User:reload_plugins()
    local empty = self.check.value.empty
    local exists = self.check.exists.module

    ---@type string[]
    local failed = {}
    for _, plugin in next, self.registered_plugins do
        if not exists(plugin) then
            table.insert(failed, plugin)
            goto continue
        end

        require(plugin)

        ::continue::
    end

    return empty(failed) and nil or failed
end

---@param self UserAPI
function User:print_loaded_plugins()
    local notify = self.util.notify.notify
    local empty = self.check.value.empty

    local msg = inspect(self.registered_plugins)

    notify(msg, 'info', {
        animate = true,
        hide_from_history = true,
        timeout = 2250,
        title = 'Loaded Plugins',
    })
end

---@param self UserAPI
function User:setup_keys()
    local wk_avail = self.maps.wk.available
    local desc = self.maps.kmap.desc
    local map_dict = self.maps.map_dict
    local is_nil = self.check.value.is_nil
    local notify = self.util.notify.notify
    local insp = inspect or vim.inspect

    ---@type RegKeysNamed
    local groups = {
        ['<leader>U'] = { group = '+User API' },
        ['<leader>UP'] = { group = '+Plugins' },
    }

    ---@type RegKeys|KeyMapDict
    local maps = {
        ['<leader>UPr'] = {
            function()
                notify('Reloading...', 'info', {
                    hide_from_history = true,
                    title = 'User API',
                    timeout = 400,
                })
                local res = self:reload_plugins()

                if not is_nil(res) then
                    notify(insp(res), 'error', {
                        hide_from_history = false,
                        timeout = 1000,
                        title = 'User API [ERROR]',
                        animate = true,
                    })
                    return
                end

                notify('Success!', 'info', {
                    hide_from_history = true,
                    timeout = 200,
                    title = 'User API',
                })
            end,
            desc('Reload All Plugins'),
        },
        ['<leader>UPl'] = {
            function() self:print_loaded_plugins() end,
            desc('Print Loaded Plugins'),
        },
    }

    if wk_avail() then
        map_dict(groups, 'wk.register', false, 'n')
    end
    map_dict(maps, 'wk.register', false, 'n')

    self.update:setup_maps()
end

---@param O? table
---@return table|UserAPI
function User.new(O)
    local is_tbl = User.check.value.is_tbl

    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = User })
end

return User

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
