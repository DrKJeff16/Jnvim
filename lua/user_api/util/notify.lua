require('user_api.types.user.util')

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
---@diagnostic disable-next-line:missing-fields
local M = {}

---@param msg string
---@param lvl? ('debug'|'error'|'info'|'off'|'trace'|'warn'|0|1|2|3|4|5)?
---@param opts? ({ level: number, title: string, once: boolean, id: string? }|notify.Config)?
function M.notify(msg, lvl, opts)
    if type(msg) ~= 'string' then
        error('(user_api.util.notify.notify): Message is not a string')
    elseif msg == '' then
        error('(user_api.util.notify.notify): Empty message')
    end

    opts = (opts ~= nil and type(opts) == 'table') and opts or {}

    local vim_lvl = vim.log.levels

    local DEFAULT_LVLS = {
        [1] = 'trace',
        [2] = 'debug',
        [3] = 'info',
        [4] = 'warn',
        [5] = 'error',
        [6] = 'off',
    }

    ---@type notify.Options
    ---@diagnostic disable-next-line:missing-fields
    local DEFAULT_OPTS = {
        animate = true,
        hide_from_history = true,
        title = 'Message',
        timeout = 700,
    }

    if exists('notify') then
        local notify = require('notify')

        if lvl == nil or (type(lvl) == 'number' and not (lvl >= 0 and lvl <= 5)) then
            lvl = DEFAULT_LVLS[vim_lvl.INFO + 1]
        elseif type(lvl) == 'number' and (lvl >= 0 and lvl <= 5) then
            lvl = DEFAULT_LVLS[math.floor(lvl) + 1]
        end

        opts = vim.tbl_deep_extend('keep', opts, DEFAULT_OPTS)

        vim.schedule(function() notify(msg, lvl, opts) end)
    else
        if type(lvl) == 'string' then
            for k, v in next, DEFAULT_LVLS do
                if lvl == v then
                    lvl = k - 1
                    break
                end
            end

            if type(lvl) == 'string' then
                lvl = vim_lvl.INFO
            end
        end

        if opts ~= nil and type(opts) == 'table' and not vim.tbl_isempty(opts) then
            vim.schedule(function() vim.notify(msg, lvl, opts) end)
        else
            vim.schedule(function() vim.notify(msg, lvl) end)
        end
    end
end

---@param msg string
---@param lvl? ('debug'|'error'|'info'|'off'|'trace'|'warn'|0|1|2|3|4|5)?
---@param opts? ({ level: number?, title: string?, once: boolean?, id: string? }|notify.Config)?
function _G.anotify(msg, lvl, opts)
    local func = function() M.notify(msg, lvl or 'info', opts or {}) end
    ---@diagnostic disable-next-line:missing-parameter
    require('plenary.async').run(func)
end

---@param msg string
---@param lvl? ('debug'|'error'|'info'|'off'|'trace'|'warn'|0|1|2|3|4|5)?
---@param opts? ({ level: number?, title: string?, once: boolean?, id: string? }|notify.Config)?
function _G.insp_anotify(msg, lvl, opts)
    local func = function() M.notify((inspect or vim.inspect)(msg), lvl or 'info', opts or {}) end
    ---@diagnostic disable-next-line:missing-parameter
    require('plenary.async').run(func)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
