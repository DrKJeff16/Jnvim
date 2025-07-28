---@diagnostic disable:missing-fields

---@module 'user_api.check'
---@module 'user_api.commands'
---@module 'user_api.config.keymaps'
---@module 'user_api.config.neovide'
---@module 'user_api.distro'
---@module 'user_api.highlight'
---@module 'user_api.maps'
---@module 'user_api.opts'
---@module 'user_api.update'
---@module 'user_api.util'

---@class User.Config
---@field keymaps table|User.Config.Keymaps|User.Config.Keymaps.CallerFun
---@field neovide User.Config.Neovide

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO

---@class UserAPI
---@field paths string[]|table
---@field FAILED string[]|table
---@field check User.Check
---@field config User.Config
---@field commands User.Commands
---@field distro User.Distro|User.Distro.CallerFun
---@field highlight User.Hl
---@field maps User.Maps
---@field opts User.Opts|User.Opts.CallerFun
---@field update User.Update
---@field util User.Util
---@field registered_plugins string[]
---@field register_plugin fun(pathstr: string, index: integer?)
---@field reload_plugins fun(): boolean,(string[]|table)
---@field setup fun()
---@field plugin_maps fun()
---@field new fun(O: table?): table|UserAPI
---@field print_loaded_plugins fun()
---@field sleep fun(t: number)
local User = {}

User.check = require('user_api.check')
User.util = require('user_api.util')
User.distro = require('user_api.distro')
User.maps = require('user_api.maps')
User.opts = require('user_api.opts')
User.commands = require('user_api.commands')
User.update = require('user_api.update')
User.highlight = require('user_api.highlight')

User.config = {}
User.config.keymaps = require('user_api.config.keymaps')
User.config.neovide = require('user_api.config.neovide')

User.paths = {}
User.FAILED = {}
User.registered_plugins = {}

-- TODO: This needs to be fixed
---@param t number
function User.sleep(t)
    local sec = tonumber(os.clock() + t)

    while os.clock() < sec do
    end
end

---@param pathstr string
---@param index? integer
function User.register_plugin(pathstr, index)
    local Value = User.check.value

    local notify = User.util.notify.notify
    local is_int = Value.is_int
    local type_not_empty = Value.type_not_empty
    local tbl_contains = vim.tbl_contains
    local in_tbl_range = Value.in_tbl_range

    index = (is_int(index) and in_tbl_range(index, User.registered_plugins)) and index or 0

    if not type_not_empty('string', pathstr) then
        error('(user_api.register_plugin): Plugin must be a non-empty string', ERROR)
    end

    if tbl_contains(User.registered_plugins, pathstr) then
        local old_idx = 0
        for i, v in next, User.registered_plugins do
            if v == pathstr then
                old_idx = i
                break
            end
        end

        table.remove(User.registered_plugins, old_idx)

        if tbl_contains({ 0, old_idx }, index) or index > #User.registered_plugins then
            table.insert(User.registered_plugins, old_idx, pathstr)
        else
            table.insert(User.registered_plugins, index, pathstr)

            notify(
                string.format('Moved `%s` from index `%d` to `%d`', pathstr, old_idx, index),
                INFO,
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
    local len = #User.registered_plugins

    if index >= 1 and index <= len then
        table.insert(User.registered_plugins, index, pathstr)
    elseif index == 0 then
        table.insert(User.registered_plugins, pathstr)
    elseif index < 0 or index > len then
        warning = 'Invalid index, appending instead'
        table.insert(User.registered_plugins, pathstr)
    end

    if warning == nil then
        return
    end

    notify(warning, WARN, {
        hide_from_history = false,
        animate = false,
        timeout = 1000,
        title = '(user_api.register_plugin)',
    })
end

---@return boolean
---@return string[]|table
function User.reload_plugins()
    local exists = User.check.exists.module

    User.FAILED = {}

    local noerr = true

    for _, plugin in next, User.registered_plugins do
        if exists(plugin) then
            require(plugin)
        else
            table.insert(User.FAILED, plugin)
            noerr = false
        end
    end

    return noerr, User.FAILED
end

function User.print_loaded_plugins()
    local notify = User.util.notify.notify

    local msg = '{'

    for k, v in next, User.registered_plugins do
        msg = string.format('%s\n  [%s]: %s', msg, tostring(k), v)
    end

    msg = msg .. '\n}'

    notify(msg, INFO, {
        animate = true,
        hide_from_history = true,
        timeout = 2250,
        title = 'Loaded Plugins',
    })
end

function User.plugin_maps()
    local Keymaps = User.config.keymaps

    local desc = User.maps.kmap.desc
    local type_not_empty = User.check.value.type_not_empty
    local displace_letter = User.util.displace_letter
    local replace = User.util.string.replace

    if not type_not_empty('table', User.registered_plugins) then
        return
    end

    User.paths = {}

    for _, v in next, User.registered_plugins do
        local fpath = vim.fn.stdpath('config') .. '/lua/plugin'
        if v:sub(1, 7) == 'plugin.' then
            v = fpath .. replace(v:sub(7), '.', '/')

            if vim.fn.isdirectory(v) == 1 then
                v = v .. '/init.lua'
            else
                v = v .. '.lua'
            end

            table.insert(User.paths, v)
        end
    end

    ---@type AllMaps
    local Keys = {}

    local group = 'A'
    local i = 1
    local cycle = 1

    while i < #User.paths do
        Keys['<leader>UP' .. group] = {
            group = '+Group ' .. group,
        }

        local name = User.paths[i]

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

function User.setup()
    local desc = User.maps.kmap.desc
    local notify = User.util.notify.notify
    local insp = inspect or vim.inspect

    ---@type AllMaps
    local Keys = {
        ['<leader>U'] = { group = '+User API' },
        ['<leader>UP'] = { group = '+Plugins' },

        ['<leader>UPr'] = {
            function()
                notify('Reloading...', INFO, {
                    hide_from_history = true,
                    title = 'User API',
                    timeout = 1000,
                    animate = true,
                })

                local res, failed = User.reload_plugins()

                if not res then
                    notify(insp(failed), 'error', {
                        hide_from_history = false,
                        timeout = 2250,
                        title = '[User API]: PLUGINS FAILED TO RELOAD',
                        animate = true,
                    })

                    return
                end

                notify('Success!', INFO, {
                    hide_from_history = false,
                    timeout = 1500,
                    title = '[User API]: PLUGINS SUCCESSFULLY RELOADED',
                    animate = true,
                })
            end,
            desc('Reload All Plugins'),
        },
        ['<leader>UPl'] = {
            User.print_loaded_plugins,
            desc('Print Loaded Plugins'),
        },
    }

    local Keymaps = User.config.keymaps
    Keymaps({ n = Keys })

    User.plugin_maps()
    User.update.setup_maps()
    User.commands.setup_keys()
    User.opts.setup_keys()
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
