local fmt = string.format

local validate = vim.validate

local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

local in_tbl = vim.tbl_contains

---@class UserAPI
---@field FAILED? string[]
local User = {}

User.util = require('user_api.util')

User.check = require('user_api.check')
User.distro = require('user_api.distro')
User.maps = require('user_api.maps')
User.opts = require('user_api.opts')
User.commands = require('user_api.commands')
User.update = require('user_api.update')
User.highlight = require('user_api.highlight')

User.config = require('user_api.config')

---@type string[]
User.paths = {}

---@type string[]
User.registered_plugins = {}

---Registers a plugin in the User API for possible reloading later.
--- ---
---@param pathstr string The path of the plugin to be registered
---@param index? integer An optional integer to insert the plugin in a given position
function User.register_plugin(pathstr, index)
    validate('pathstr', pathstr, 'string', false)
    validate('index', index, 'number', true, 'integer')

    local Value = User.check.value

    local type_not_empty = Value.type_not_empty
    local tbl_contains = vim.tbl_contains
    local in_tbl_range = Value.in_tbl_range

    local _NAME = 'user_api.register_plugin'

    index = index or 0
    index = in_tbl_range(index, User.registered_plugins) and index or 0

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
                fmt('(%s): Moved `%s` from index `%d` to `%d`', _NAME, pathstr, old_idx, index),
                INFO
            )
        end

        return
    end

    if index >= 1 and index <= #User.registered_plugins then
        table.insert(User.registered_plugins, index, pathstr)
        return
    end

    if index < 0 or index > #User.registered_plugins then
        vim.notify('Invalid index, appending instead', WARN)
    end
    table.insert(User.registered_plugins, pathstr)
end

---@param pathstr string The path of the plugin to be de-registered
function User.deregister_plugin(pathstr)
    validate('pathstr', pathstr, 'string', false)

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

---@return boolean noerr Whether the reloading is successful
---@return string[]|table User.FAILED A list of failed plugins (if any)
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
        msg = fmt('%s\n%s', msg, v)
    end

    vim.notify(msg, INFO)
end

function User.setup_maps()
    local Keymaps = User.config.keymaps
    local desc = User.maps.desc
    local type_not_empty = User.check.value.type_not_empty
    local displace_letter = User.util.displace_letter
    local replace = User.util.string.replace
    local is_dir = User.check.exists.vim_isdir

    if not type_not_empty('table', User.registered_plugins) then
        return
    end

    User.paths = {}

    for _, v in next, User.registered_plugins do
        local fpath = vim.fn.stdpath('config') .. '/lua/plugin'
        if v:sub(1, 7) == 'plugin.' then
            v = fpath .. replace(v:sub(7), '.', '/')
            v = v .. (is_dir(v) and '/init.lua' or '.lua')

            table.insert(User.paths, v)
        end
    end

    ---@type AllMaps
    local Keys = {
        ['<leader>Pe'] = { group = '+Edit Plugin Config' },
    }

    local group, i, cycle = 'a', 1, 1

    while i < #User.paths do
        Keys['<leader>Pe' .. group] = { group = '+Group ' .. string.upper(group) }

        local name = User.paths[i]

        Keys['<leader>Pe' .. group .. tostring(cycle)] = {
            function()
                vim.cmd.tabnew(name)
            end,
            desc(vim.fn.fnamemodify(name, ':h:t') .. '/' .. vim.fn.fnamemodify(name, ':t')),
        }

        if cycle == 9 then
            group = displace_letter(group, 'next')
            cycle = 1
        elseif cycle < 9 then
            cycle = cycle + 1
        end

        i = i + 1
    end

    Keymaps({ n = Keys })
end

---@param opts? table
function User.setup(opts)
    validate('opts', opts, 'table', true)

    opts = opts or {} -- luacheck: ignore

    local desc = User.maps.desc
    local insp = inspect or vim.inspect

    ---@type AllMaps
    local Keys = {
        ['<leader>U'] = { group = '+User API' },
        ['<leader>P'] = { group = '+Plugins' },

        ['<leader>Pr'] = {
            function()
                vim.notify('Reloading...', INFO)

                local res, failed = User.reload_plugins()

                if not (res or vim.tbl_isempty(failed)) then
                    vim.notify(insp(failed), ERROR)
                    return
                end

                vim.notify('Success!', INFO)
            end,
            desc('Reload All Plugins'),
        },
        ['<leader>Pl'] = {
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
    User.opts.setup_cmds()

    -- Call the User API file associations and other autocmds
    User.util.setup_autocmd()

    -- Call runtimepath optimizations for specific platforms
    User.distro()

    User.config.neovide.setup()
end

return User

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
