---@module 'notify'

---@alias VimNotifyLvl
---|0
---|1
---|2
---|3
---|4
---|5

---@alias NotifyLvl
---|'debug'
---|'error'
---|'info'
---|'off'
---|'trace'
---|'warn'

---@class NotifyOpts
---@field title? string Defaults to `'Message'`
---@field icon? string
---@field timeout? integer|boolean Defaults to `700`
---@field on_open? fun(...)
---@field on_close? fun(...)
---@field keep? fun(...)
---@field render? string|fun(...)
---@field replace? integer
---@field hide_from_history? boolean Defaults to `false`
---@field animate? boolean Defaults to `true`

local TRACE = vim.log.levels.TRACE -- `0`
local DEBUG = vim.log.levels.DEBUG -- `1`
local INFO = vim.log.levels.INFO -- `2`
local WARN = vim.log.levels.WARN -- `3`
local ERROR = vim.log.levels.ERROR -- `4`
local OFF = vim.log.levels.OFF -- `5`

--- Can't use `user_api.check.exists.module()` here as said module might
--- end up requiring this module, so let's avoid an import loop,
--- shall we?
---@param mod string The module `require()` string
---@return boolean ok Whether the module exists
local function exists(mod)
    local ok, _ = pcall(require, mod)
    return ok
end

---@class User.Util.Notify
local Notify = {}

---@type notify.Options
---@diagnostic disable-next-line:missing-fields
Notify.Opts = {
    animate = false,
    hide_from_history = false,
    title = 'Message',
    timeout = 1000,
    -- icon = '',
    -- render = '',
    -- replace = 1,
    -- on_open = function() end,
    -- on_close = function() end,
    -- keep = function() end,
}

---@class User.Util.Notify.Levels
Notify.Levels = {
    [TRACE] = 'trace',
    [DEBUG] = 'debug',
    [INFO] = 'info',
    [WARN] = 'warn',
    [ERROR] = 'error',
    [OFF] = 'off',
    TRACE = TRACE,
    DEBUG = DEBUG,
    INFO = INFO,
    WARN = WARN,
    ERROR = ERROR,
    OFF = OFF,
}

---@param msg string
---@param lvl? NotifyLvl|VimNotifyLvl
---@param opts? notify.Options
function Notify.notify(msg, lvl, opts)
    if type(msg) ~= 'string' then
        error('(user_api.util.notify.notify): Message is not a string')
    end
    if msg == '' then
        error('(user_api.util.notify.notify): Empty message')
    end

    lvl = (not vim.tbl_contains({ 'string', 'number' }, type(lvl))) and 'info' or lvl

    opts = (opts ~= nil and type(opts) == 'table') and opts or Notify.Opts

    if exists('notify') then
        local notify = require('notify')

        if type(lvl) == 'number' then
            lvl = math.floor(lvl)
            lvl = (lvl <= OFF and lvl >= TRACE) and Notify.Levels[lvl] or Notify.Levels[INFO]
        elseif not vim.tbl_contains(Notify.Levels, string.lower(lvl)) then
            lvl = Notify.Levels[INFO]
        end

        opts = vim.tbl_deep_extend('keep', opts, Notify.Opts)

        vim.schedule(function()
            notify(msg, lvl, opts)
        end)
    else
        if type(lvl) == 'string' then
            if vim.tbl_contains(Notify.Levels, string.lower(lvl)) then
                lvl = Notify.Levels[string.upper(lvl)]
            end
        elseif type(lvl) == 'number' then
            if lvl < TRACE or lvl > OFF then
                lvl = INFO
            end
        else
            lvl = INFO
        end

        vim.schedule(function()
            vim.notify(msg, lvl, opts)
        end)
    end
end

---@param lvl VimNotifyLvl
---@return fun(args: vim.api.keyset.create_user_command.command_args)
local function gen_cmd_lvl(lvl)
    return function(args)
        local notify = Notify.notify
        local data = args.args

        if data == '' then
            return
        end

        local opts = {
            animate = true,
            title = 'Message',
            timeout = 1750,
            hide_from_history = args.bang,
        }

        notify(data, lvl, opts)
    end
end

vim.api.nvim_create_user_command('Notify', gen_cmd_lvl(vim.log.levels.INFO), {
    bang = true,
    nargs = '+',
    force = true,
})
vim.api.nvim_create_user_command('NotifyInfo', gen_cmd_lvl(vim.log.levels.INFO), {
    bang = true,
    nargs = '+',
    force = true,
})
vim.api.nvim_create_user_command('NotifyWarn', gen_cmd_lvl(vim.log.levels.WARN), {
    bang = true,
    nargs = '+',
    force = true,
})
vim.api.nvim_create_user_command('NotifyError', gen_cmd_lvl(vim.log.levels.ERROR), {
    bang = true,
    nargs = '+',
    force = true,
})

return Notify

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
