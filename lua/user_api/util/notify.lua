require('user_api.types.user.util')

--- Can't use `check.exists.module()` here as said module might
--- end up requiring this module, so let's avoid an import loop,
--- shall we?
---@param mod string
---@return boolean ok
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
        error('(user_api.util.notify.notify): Empty message')
    end

    opts = (type(opts) == 'table') and opts or {}

    local vim_lvl = vim.log.levels

    -- WARN: DO NOT SORT
    local DEFAULT_LVLS = {
        'trace',
        'debug',
        'info',
        'warn',
        'error',
        'off',
    }

    ---@type notify.Options
    ---@diagnostic disable-next-line:missing-fields
    local DEFAULT_OPTS = {
        animate = true,
        hide_from_history = false,
        title = 'Message',
        timeout = 700,
    }

    if exists('notify') then
        local notify = require('notify')

        if type(lvl) == 'number' and (lvl >= 0 and lvl <= 5) then
            lvl = DEFAULT_LVLS[math.floor(lvl) + 1]
        elseif type(lvl) == 'number' then
            lvl = DEFAULT_LVLS[3]
        end

        if opts ~= nil and type(opts) == 'table' and not vim.tbl_isempty(opts) then
            for key, v in next, DEFAULT_OPTS do
                opts[key] = (opts[key] ~= nil and type(v) == type(opts[key])) and opts[key] or v
            end
        else
            for key, v in next, DEFAULT_OPTS do
                opts[key] = v
            end
        end

        notify(msg, lvl, opts)
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
            vim.notify(msg, lvl, opts)
        else
            vim.notify(msg, lvl)
        end
    end
end

---@param msg string
---@param lvl? ('debug'|'error'|'info'|'off'|'trace'|'warn'|0|1|2|3|4|5)?
---@param opts? ({ level: number, title: string, once: boolean, id: string? }|notify.Config)?
function _G.anotify(msg, lvl, opts)
    ---@diagnostic disable-next-line:missing-parameter
    require('plenary.async').run(function() M.notify(msg, lvl, opts) end)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
