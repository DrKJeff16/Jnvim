local MODSTR = 'user_api'

local in_list = vim.list_contains

local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

---@class UserAPI
---@field FAILED? string[]
local User = {}

---@type string[]
User.paths = {}

---@type string[]
User.registered_plugins = {}

User.util = require('user_api.util')
User.check = require('user_api.check')
User.distro = require('user_api.distro')
User.maps = require('user_api.maps')
User.opts = require('user_api.opts')
User.commands = require('user_api.commands')
User.update = require('user_api.update')
User.highlight = require('user_api.highlight')
User.config = require('user_api.config')

---Registers a plugin in the User API for possible reloading later.
--- ---
---@param pathstr string The path of the plugin to be registered
---@param index? integer An optional integer to insert the plugin in a given position
function User.register_plugin(pathstr, index)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('pathstr', pathstr, 'string', false)
        vim.validate('index', index, 'number', true, 'integer')
    else
        vim.validate({
            pathstr = { pathstr, 'string' },
            index = { index, { 'number', 'nil' } },
        })
    end

    if pathstr == '' then
        return
    end

    local _NAME = MODSTR .. '.register_plugin'
    local in_tbl_range = User.check.value.in_tbl_range

    index = index or 0
    index = in_tbl_range(index, User.registered_plugins) and index or 0

    if in_list(User.registered_plugins, pathstr) then
        local old_idx = 0
        for i, v in ipairs(User.registered_plugins) do
            if v == pathstr then
                old_idx = i
                break
            end
        end

        table.remove(User.registered_plugins, old_idx)
        if in_list({ 0, old_idx }, index) or index > #User.registered_plugins then
            table.insert(User.registered_plugins, old_idx, pathstr)
        else
            vim.notify(
                ('(%s): Moved `%s` from index `%d` to `%d`'):format(_NAME, pathstr, old_idx, index),
                INFO
            )
            table.insert(User.registered_plugins, index, pathstr)
        end

        return
    end

    if index >= 1 and index <= #User.registered_plugins then
        table.insert(User.registered_plugins, index, pathstr)
    elseif index < 0 or index > #User.registered_plugins then
        vim.notify(('(%s): Invalid index, appending instead'):format(_NAME), WARN)
        table.insert(User.registered_plugins, pathstr)
    end
end

---@param pathstr string The path of the plugin to be de-registered
function User.deregister_plugin(pathstr)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('pathstr', pathstr, 'string', false)
    else
        vim.validate({ pathstr = { pathstr, 'string' } })
    end

    if pathstr == '' or not in_list(User.registered_plugins, pathstr) then
        return
    end

    local idx = 0
    for i, v in ipairs(User.registered_plugins) do
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

    for _, plugin in ipairs(User.registered_plugins) do
        if not User.check.exists.module(plugin) then
            table.insert(User.FAILED, plugin)
            noerr = false
        end
    end

    return noerr, User.FAILED
end

function User.print_loaded_plugins()
    local msg = ''
    for _, v in ipairs(User.registered_plugins) do
        msg = ('%s\n%s'):format(msg, v)
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
    for _, v in ipairs(User.registered_plugins) do
        local fpath = vim.fn.stdpath('config') .. '/lua/plugin'
        if v:sub(1, 7) == 'plugin.' then
            table.insert(
                User.paths,
                ('%s%s%s'):format(
                    fpath,
                    replace(v:sub(7), '.', '/'),
                    (is_dir(v) and '/init.lua' or '.lua')
                )
            )
        end
    end

    ---@type AllMaps
    local Keys = {
        ['<leader>Pe'] = { group = '+Edit Plugin Config' },
    }

    local group, i, cycle = 'a', 1, 1
    while i < #User.paths do
        local name = User.paths[i]

        Keys['<leader>Pe' .. group] = { group = '+Group ' .. group:upper() }
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
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('opts', opts, 'table', true, 'table?')
    else
        vim.validate({ opts = { opts, { 'table', 'nil' } } })
    end
    opts = opts or {} -- luacheck: ignore

    local desc = User.maps.desc
    local insp = vim.inspect

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
    User.update.setup()
    User.opts.setup_maps()
    User.opts.setup_cmds()
    User.util.setup_autocmd() -- Call the User API file associations and other autocmds
    User.distro() -- Call runtimepath optimizations for specific platforms
    User.config.neovide.setup()
end

return User

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
