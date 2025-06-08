---@diagnostic disable:missing-fields
---@diagnostic disable:missing-parameter

---@module 'user_api.types.user.util'

local Lvl = vim.log.levels

local TRACE = Lvl.TRACE
local DEBUG = Lvl.DEBUG
local INFO = Lvl.INFO
local WARN = Lvl.WARN
local ERROR = Lvl.ERROR
local OFF = Lvl.OFF

--- Can't use `check.exists.module()` here as said module might
--- end up requiring this module, so let's avoid an import loop,
--- shall we?
---@param mod string The module `require()` string
---@return boolean ok Whether the module exists
local function exists(mod)
    local ok, _ = pcall(require, mod)
    return ok
end

---@type User.Util.Notify
local Notify = {}

---@type notify.Options
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

---@type User.Util.Notify.Levels
Notify.Levels = {
    [TRACE] = 'trace',
    [DEBUG] = 'debug',
    [INFO] = 'info',
    [WARN] = 'warn',
    [ERROR] = 'error',
    [OFF] = 'off',
    TRACE = 0,
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
    OFF = 5,
}

---@param msg string
---@param lvl? NotifyLvl|VimNotifyLvl
---@param opts? notify.Options
function Notify.notify(msg, lvl, opts)
    if type(msg) ~= 'string' then
        error('(user_api.util.notify.notify): Message is not a string', ERROR)
    elseif msg == '' then
        error('(user_api.util.notify.notify): Empty message', ERROR)
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

        vim.schedule(function() notify(msg, lvl, opts) end)
    else
        if type(lvl) == 'string' and vim.tbl_contains(Notify.Levels, string.lower(lvl)) then
            lvl = Notify.Levels[string.upper(lvl)]
        elseif type(lvl) == 'string' then
            lvl = INFO
        elseif type(lvl) == 'number' and (lvl < TRACE or lvl > OFF) then
            lvl = INFO
        end

        vim.schedule(function() vim.notify(msg, lvl, opts) end)
    end
end

---@param msg string
---@param lvl? NotifyLvl|VimNotifyLvl
---@param opts? table|notify.Options
function _G.anotify(msg, lvl, opts)
    local func = function() Notify.notify(msg, lvl or 'info', opts or {}) end
    require('plenary.async').run(func)
end

---@param msg string
---@param lvl? NotifyLvl|VimNotifyLvl
---@param opts? table|notify.Options
function _G.insp_anotify(msg, lvl, opts)
    local func = function() Notify.notify((inspect or vim.inspect)(msg), lvl or 'info', opts or {}) end

    require('plenary.async').run(func)
end

return Notify

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
