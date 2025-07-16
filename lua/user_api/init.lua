---@diagnostic disable:missing-fields

---@module 'user_api.types.user'

local ERROR = vim.log.levels.ERROR

---@type UserAPI
local User = {}

User.paths = {}
User.FAILED = {}

User.config = {}

User.config.keymaps = require('user_api.config.keymaps')

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

---@type User.Opts|User.Opts.CallerFun
User.opts = require('user_api.opts')

---@type User.Update
User.update = require('user_api.update')

---@type User.Util
User.util = require('user_api.util')

---@type string[]
User.registered_plugins = {}

-- TODO: This needs to be fixed
---@param t number
function User.sleep(t)
    local sec = tonumber(os.clock() + t)

    while os.clock() < sec do
    end
end

---@param self UserAPI
---@param pathstr string
---@param index? integer
function User:register_plugin(pathstr, index)
    local Value = self.check.value

    local notify = self.util.notify.notify
    local is_nil = Value.is_nil
    local is_int = Value.is_int
    local type_not_empty = Value.type_not_empty
    local tbl_contains = vim.tbl_contains
    local in_tbl_range = Value.in_tbl_range

    index = (is_int(index) and in_tbl_range(index, self.registered_plugins)) and index or 0

    if not type_not_empty('string', pathstr) then
        error('(user_api:register_plugin): Plugin must be a non-empty string', ERROR)
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
---@return boolean
---@return string[]|table
function User:reload_plugins()
    local exists = self.check.exists.module

    self.FAILED = {}

    local noerr = true

    for _, plugin in next, self.registered_plugins do
        if exists(plugin) then
            require(plugin)
        else
            table.insert(self.FAILED, plugin)
            noerr = false
        end
    end

    return noerr, self.FAILED
end

---@param self UserAPI
function User:print_loaded_plugins()
    local notify = self.util.notify.notify

    notify(inspect(self.registered_plugins), 'info', {
        animate = true,
        hide_from_history = true,
        timeout = 2250,
        title = 'Loaded Plugins',
    })
end

---@param self UserAPI
function User:plugin_maps()
    local Keymaps = require('user_api.config.keymaps')

    local desc = self.maps.kmap.desc
    local type_not_empty = self.check.value.type_not_empty
    local displace_letter = self.util.displace_letter
    local replace = self.util.string.replace

    if not type_not_empty('table', self.registered_plugins) then
        return
    end

    self.paths = {}

    for _, v in next, self.registered_plugins do
        local fpath = vim.fn.stdpath('config') .. '/lua/plugin'
        if v:sub(1, 7) == 'plugin.' then
            v = fpath .. replace(v:sub(7), '.', '/')

            if vim.fn.isdirectory(v) == 1 then
                v = v .. '/init.lua'
            else
                v = v .. '.lua'
            end

            table.insert(self.paths, v)
        end
    end

    ---@type AllMaps
    local Keys = {}

    local group = 'A'
    local i = 1
    local cycle = 1

    while i < #self.paths do
        Keys['<leader>UP' .. group] = {
            group = '+Group ' .. group,
        }

        local name = self.paths[i]

        Keys['<leader>UP' .. group .. tostring(cycle)] = {
            function()
                vim.cmd.tabnew(name)
            end,
            desc(name),
        }

        if cycle == 9 then
            group = displace_letter(group, 'next', false)
            cycle = 1
        elseif cycle < 9 then
            cycle = cycle + 1
        end

        i = i + 1
    end

    Keymaps({ n = Keys })
end

---@param self UserAPI
function User:setup_keys()
    local desc = self.maps.kmap.desc
    local notify = self.util.notify.notify
    local insp = inspect or vim.inspect

    ---@type AllMaps
    local Keys = {
        ['<leader>U'] = { group = '+User API' },
        ['<leader>UP'] = { group = '+Plugins' },

        ['<leader>UPr'] = {
            function()
                notify('Reloading...', 'info', {
                    hide_from_history = true,
                    title = 'User API',
                    timeout = 1000,
                    animate = true,
                })

                local res, failed = self:reload_plugins()

                if not res then
                    notify(insp(failed), 'error', {
                        hide_from_history = false,
                        timeout = 2250,
                        title = '[User API]: PLUGINS FAILED TO RELOAD',
                        animate = true,
                    })

                    return
                end

                notify('Success!', 'info', {
                    hide_from_history = false,
                    timeout = 1500,
                    title = '[User API]: PLUGINS SUCCESSFULLY RELOADED',
                    animate = true,
                })
            end,
            desc('Reload All Plugins'),
        },
        ['<leader>UPl'] = {
            function()
                self:print_loaded_plugins()
            end,
            desc('Print Loaded Plugins'),
        },
    }

    local Keymaps = require('user_api.config.keymaps')
    Keymaps({ n = Keys })

    self:plugin_maps()
    self.update:setup_maps()
    self.commands:setup_keys()
    self.opts:setup_keys()
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
