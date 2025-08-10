local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

---@class UserAPI
local User = {}

User.check = require('user_api.check')
User.util = require('user_api.util')
User.distro = require('user_api.distro')
User.maps = require('user_api.maps')
User.opts = require('user_api.opts')
User.commands = require('user_api.commands')
User.update = require('user_api.update')
User.highlight = require('user_api.highlight')

---@class User.Config
User.config = {
    keymaps = require('user_api.config.keymaps'),
    neovide = require('user_api.config.neovide'),
}

---@type string[]|table
User.paths = {}

---@type string[]|table
User.FAILED = {}

---@type string[]|table
User.registered_plugins = {}

---Registers a plugin in the User API for possible reloading later.
--- ---
---@param pathstr string The path of the plugin to be registered
---@param index? integer An optional integer to insert the plugin in a given position
function User.register_plugin(pathstr, index)
    local _NAME = 'user_api.register_plugin'
    local Value = User.check.value

    local is_int = Value.is_int
    local type_not_empty = Value.type_not_empty
    local tbl_contains = vim.tbl_contains
    local in_tbl_range = Value.in_tbl_range

    index = (is_int(index) and in_tbl_range(index, User.registered_plugins)) and index or 0

    if not type_not_empty('string', pathstr) then
        return
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

            vim.notify(
                string.format(
                    '(%s): Moved `%s` from index `%d` to `%d`',
                    _NAME,
                    pathstr,
                    old_idx,
                    index
                ),
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

    vim.notify(warning, WARN)
end

---@param pathstr string The path of the plugin to be de-registered
function User.deregister_plugin(pathstr)
    local Value = User.check.value

    local type_not_empty = Value.type_not_empty
    local in_tbl = vim.tbl_contains

    if not type_not_empty('string', pathstr) then
        return
    end

    if not in_tbl(User.registered_plugins, pathstr) then
        return
    end

    local idx = 0

    for i, v in next, User.registered_plugins do
        if v == pathstr then
            idx = i
            break
        end
    end

    table.remove(User.registered_plugins, idx)
end

---@return boolean
---@return string[]|table
function User.reload_plugins()
    User.FAILED = {}

    local noerr = true

    for _, plugin in next, User.registered_plugins do
        if not User.check.exists.module(plugin) then
            table.insert(User.FAILED, plugin)
            noerr = false
        end
    end

    return noerr, User.FAILED
end

function User.print_loaded_plugins()
    local msg = ''

    for _, v in next, User.registered_plugins do
        msg = string.format('%s\n%s', msg, v)
    end

    vim.notify(msg, INFO)
end

function User.setup_maps()
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
    local insp = inspect or vim.inspect

    ---@type AllMaps
    local Keys = {
        ['<leader>U'] = { group = '+User API' },
        ['<leader>UP'] = { group = '+Plugins' },

        ['<leader>UPr'] = {
            function()
                vim.notify('Reloading...', INFO)

                local res, failed = User.reload_plugins()

                if not res then
                    vim.notify(insp(failed), ERROR)

                    return
                end

                vim.notify('Success!', INFO)
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

    User.setup_maps()
    User.commands.setup()
    User.update.setup_maps()
    User.opts.setup_maps()
    User.config.neovide.setup()

    -- Call the User API file associations and other autocmds
    User.util.setup_autocmd()

    -- Call runtimepath optimizations for specific platforms
    User.distro()
end

---@return table|UserAPI
function User.new()
    return setmetatable({}, { __index = User })
end

return User

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
