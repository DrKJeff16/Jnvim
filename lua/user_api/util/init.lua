require('user_api.types.user.util')

local curr_buf = vim.api.nvim_get_current_buf
local optset = vim.api.nvim_set_option_value
local in_tbl = vim.tbl_contains

local ERROR = vim.log.levels.ERROR

---@type User.Util
---@diagnostic disable-next-line:missing-fields
local M = {}

M.notify = require('user_api.util.notify')
M.au = require('user_api.util.autocmd')
M.string = require('user_api.util.string')

---@param T table<string|integer, any>
---@param steps? integer
---@param direction? 'l'|'r'
---@return table<string|integer, any> res
function M.mv_tbl_values(T, steps, direction)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl
    local is_str = Value.is_str
    local is_int = Value.is_int
    local empty = Value.empty

    if not is_tbl(T) then
        error("(user_api.util.mv_tbl_values): Input isn't a table", ERROR)
    end

    if empty(T) then
        return T
    end

    steps = (is_int(steps) and steps > 0) and steps or 1
    direction = (is_str(direction) and in_tbl({ 'l', 'r' }, direction)) and direction or 'r'

    ---@class DirectionFuns
    ---@field r fun(t: table<string|integer, any>): res: table<string|integer, any>
    ---@field l fun(t: table<string|integer, any>): res: table<string|integer, any>

    ---@type DirectionFuns
    local direction_funcs = {
        ---@param t table<string|integer, any>
        ---@return table<string|integer, any> res
        r = function(t)
            ---@type (string|integer)[]
            local keys = vim.tbl_keys(t)
            table.sort(keys)
            local n_keys = #keys

            ---@type table<string|integer, any>
            local res = {}

            for i, v in next, keys do
                if i == 1 then
                    res[v] = t[keys[n_keys]]
                else
                    res[v] = t[keys[i - 1]]
                end
            end

            return res
        end,

        ---@param t table<string|integer, any>
        ---@return table<string|integer, any> res
        l = function(t)
            ---@type (string|integer)[]
            local keys = vim.tbl_keys(t)
            table.sort(keys)
            local n_keys = #keys

            ---@type table<string|integer, any>
            local res = {}

            for i, v in next, keys do
                if i == n_keys then
                    res[v] = t[keys[1]]
                elseif i < n_keys and i > 0 then
                    res[v] = t[keys[i + 1]]
                end
            end

            return res
        end,
    }

    ---@type table<string|integer, any>
    local res = T

    while steps > 0 do
        res = direction_funcs[direction](res)
        steps = steps - 1
    end

    return res
end

---@param x boolean
---@param y boolean
---@return boolean
function M.xor(x, y)
    if not require('user_api.check.value').is_bool({ x, y }, true) then
        M.notify.notify('An argument is not of boolean type', 'error', {
            hide_from_history = false,
            timeout = 850,
            title = '(user_api.util.xor)',
        })
        return false
    end

    return (x and not y) or (not x and y)
end

---@param T table<string|integer, any>
---@param fields string|integer|(string|integer)[]
---@return table<string|integer, any> res
function M.strip_fields(T, fields)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl
    local is_str = Value.is_str
    local empty = Value.empty
    local field = Value.fields

    if not is_tbl(T) then
        error('(user_api.util.strip_fields): Argument is not a table')
    end

    if empty(T) then
        return T
    end

    if not (is_str(fields) or is_tbl(fields)) or empty(fields) then
        return T
    end

    ---@type table<string|integer, any>
    local res = {}

    if is_str(fields) then
        if not field(fields, T) then
            return T
        end

        for k, v in next, T do
            if k ~= fields then
                res[k] = v
            end
        end
    else
        for k, v in next, T do
            if not in_tbl(fields, k) then
                res[k] = v
            end
        end
    end

    return res
end

---@param T table<string|integer, any>
---@param values any[]
---@param max_instances? integer
---@return table<string|integer, any> res
function M.strip_values(T, values, max_instances)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl
    local is_int = Value.is_int
    local empty = Value.empty

    if not is_tbl(T) then
        error('(user_api.util.strip_values): Not a table')
    end
    if not is_tbl(values) or empty(values) then
        error('(user_api.util.strip_values): No values given')
    end

    max_instances = is_int(max_instances) and max_instances or 0

    ---@type table<string|integer, any>
    local res = {}
    local count = 0

    for k, v in next, T do
        if M.xor(max_instances == 0, max_instances ~= 0 and max_instances > count) then
            if not in_tbl(values, v) and is_int(k) then
                table.insert(res, v)
            elseif not in_tbl(values, v) then
                res[k] = v
            else
                count = count + 1
            end
        elseif is_int(k) then
            table.insert(res, v)
        else
            res[k] = v
        end
    end

    return res
end

---@param s string
---@param bufnr? integer
---@return fun()
function M.ft_set(s, bufnr)
    local Value = require('user_api.check.value')

    local is_int = Value.is_int
    local is_str = Value.is_str

    bufnr = is_int(bufnr) and bufnr or curr_buf()

    return function()
        if not is_str(s) then
            optset('ft', '', { buf = bufnr })
        else
            optset('ft', s, { buf = bufnr })
        end
    end
end

---@param bufnr? integer
---@return string
function M.bt_get(bufnr)
    bufnr = require('user_api.check.value').is_int(bufnr) and bufnr or curr_buf()

    return vim.api.nvim_get_option_value('bt', { buf = bufnr })
end

---@param bufnr? integer
---@return string
function M.ft_get(bufnr)
    bufnr = require('user_api.check.value').is_int(bufnr) and bufnr or curr_buf()

    return vim.api.nvim_get_option_value('ft', { buf = bufnr })
end

function M.assoc()
    local au_repeated_events = M.au.au_repeated_events

    local group = vim.api.nvim_create_augroup('UserAssocs', { clear = true })

    ---@type AuRepeatEvents[]
    local AUS = {
        { -- NOTE: Keep this as first element for `orgmode` addition
            events = { 'BufNewFile', 'BufReadPre' },
            opts_tbl = {
                { pattern = '.spacemacs', callback = M.ft_set('lisp'), group = group },
                { pattern = '.clangd', callback = M.ft_set('yaml'), group = group },
                { pattern = '*.norg', callback = M.ft_set('norg'), group = group },
            },
        },
        {
            events = { 'BufRead', 'WinEnter', 'BufReadPost', 'TabEnter' },
            opts_tbl = {
                {
                    pattern = '*.txt',
                    group = group,
                    callback = function()
                        if
                            not in_tbl({
                                M.ft_get(curr_buf()),
                                M.bt_get(curr_buf()),
                            }, 'help')
                        then
                            return
                        end

                        vim.cmd.wincmd('=')
                    end,
                },
            },
        },
        {
            events = { 'FileType' },
            opts_tbl = {
                {
                    pattern = 'help',
                    group = group,
                    callback = function()
                        if M.bt_get(curr_buf()) ~= 'help' then
                            return
                        end

                        vim.cmd.wincmd('=')
                    end,
                },
                {
                    pattern = { 'c', 'cpp' },
                    group = group,
                    callback = function()
                        local buf_opts = {
                            ts = 2,
                            sts = 2,
                            sw = 2,
                            ai = true,
                            si = true,
                            et = true,
                            ci = false,
                            pi = false,
                        }

                        for option, val in next, buf_opts do
                            optset(option, val, { buf = curr_buf() })
                        end
                    end,
                },
                {
                    pattern = 'markdown',
                    group = group,
                    callback = function()
                        local opts = {
                            ts = 2,
                            sts = 2,
                            sw = 2,
                            et = true,
                            ai = true,
                            si = true,
                            ci = false,
                            pi = false,
                        }

                        for option, val in next, opts do
                            optset(option, val, { buf = curr_buf() })
                        end
                    end,
                },
                {
                    pattern = 'lua',
                    group = group,
                    callback = function()
                        local buf = curr_buf()

                        -- Make sure the buffer is modifiable
                        if not vim.api.nvim_get_option_value('modifiable', { buf = buf }) then
                            return
                        end

                        if require('user_api.check.exists').executable('stylua') then
                            local map_dict = require('user_api.maps').map_dict
                            local desc = require('user_api.maps.kmap').desc

                            map_dict({
                                ['<leader><C-l>'] = {
                                    ':silent !stylua %<CR>',
                                    desc('Format With `stylua`', true, buf),
                                },
                            }, 'wk.register', false, 'n', buf)
                        end
                    end,
                },
                {
                    pattern = 'python',
                    group = group,
                    callback = function()
                        local buf = curr_buf()

                        if require('user_api.check.exists').executable('isort') then
                            local map_dict = require('user_api.maps').map_dict
                            local desc = require('user_api.maps.kmap').desc

                            map_dict({
                                ['<leader><C-l>'] = {
                                    ':silent !isort %<CR>',
                                    desc('Format With `isort`', true, buf),
                                },
                            }, 'wk.register', false, 'n', buf)
                        end
                    end,
                },
            },
        },
    }

    local ok, _ = pcall(require, 'orgmode')

    if ok then
        table.insert(AUS[1].opts_tbl, {
            group = group,
            pattern = '*.org',
            callback = M.ft_set('org'),
        })
    end

    for _, T in next, AUS do
        au_repeated_events(T)
    end
end

---@param c string
---@param direction? 'next'|'prev'
---@param cycle? boolean
---@return string
function M.displace_letter(c, direction, cycle)
    local Value = require('user_api.check.value')
    local A = M.string.alphabet

    local fields = Value.fields
    local is_str = Value.is_str
    local is_bool = Value.is_bool
    local mv = M.mv_tbl_values

    direction = (is_str(direction) and in_tbl({ 'next', 'prev' }, direction)) and direction
        or 'next'
    cycle = is_bool(cycle) and cycle or false

    if c == '' then
        return 'a'
    end

    local lower = vim.deepcopy(A.lower_map)
    local upper = vim.deepcopy(A.upper_map)

    if direction == 'prev' and fields(c, lower) then
        return mv(lower, 1, 'r')[c]
    elseif direction == 'next' and fields(c, lower) then
        return mv(lower, 1, 'l')[c]
    elseif direction == 'prev' and fields(c, upper) then
        return mv(upper, 1, 'r')[c]
    elseif direction == 'next' and fields(c, upper) then
        return mv(upper, 1, 'l')[c]
    end

    error('(user_api.util.displace_letter): Invalid argument `' .. c .. '`', ERROR)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
