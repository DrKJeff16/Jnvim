---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

require('user.types.user.util')

---@type User.Util
---@diagnostic disable-next-line:missing-fields
local M = {}

function M.xor(x, y)
    local is_bool = require('user.check.value').is_bool

    if not is_bool({ x, y }, true) then
        error('(user.util.xor): An argument is not of boolean type')
    end

    return (x and not y) or (not x and y)
end

function M.strip_fields(T, fields)
    local is_tbl = require('user.check.value').is_tbl
    local is_str = require('user.check.value').is_str
    local is_int = require('user.check.value').is_int
    local empty = require('user.check.value').empty
    local field = require('user.check.value').fields

    if not is_tbl(T) then
        error('(user.util.strip_fields): Argument is not a table')
    end

    if empty(T) then
        return T
    end

    if not (is_str(fields) or is_tbl(fields)) or empty(fields) then
        return T
    end

    ---@type User.Maps.Keymap.Opts
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
            if not vim.tbl_contains(fields, k) then
                res[k] = v
            end
        end
    end

    return res
end

function M.strip_values(T, values, max_instances)
    local is_tbl = require('user.check.value').is_tbl
    local is_nil = require('user.check.value').is_nil
    local is_str = require('user.check.value').is_str
    local is_int = require('user.check.value').is_int
    local empty = require('user.check.value').empty

    if not is_tbl(T) then
        error('(user.util.strip_values): Not a table')
    end
    if not is_tbl(values) or empty(values) then
        error('(user.util.strip_values): No values given')
    end

    local xor = M.xor

    max_instances = is_int(max_instances) and max_instances or 0

    local res = {}

    local count = 0

    for k, v in next, T do
        if xor(max_instances == 0, max_instances ~= 0 and max_instances > count) then
            if not vim.tbl_contains(values, v) and is_int(k) then
                table.insert(res, v)
            elseif not vim.tbl_contains(values, v) then
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

function M.ft_set(s, bufnr)
    local is_int = require('user.check.value').is_int
    local is_str = require('user.check.value').is_str

    bufnr = is_int(bufnr) and bufnr or 0

    return function()
        if is_str(s) then
            vim.api.nvim_set_option_value('ft', s, { buf = bufnr })
        end
    end
end

function M.ft_get(bufnr)
    local is_int = require('user.check.value').is_int

    bufnr = is_int(bufnr) and bufnr or 0

    return vim.api.nvim_get_option_value('ft', { buf = bufnr })
end

M.notify = require('user.util.notify')

function M.assoc()
    local ft = M.ft_set
    local is_nil = require('user.check.value').is_nil
    local is_fun = require('user.check.value').is_fun
    local is_tbl = require('user.check.value').is_tbl
    local is_str = require('user.check.value').is_str
    local empty = require('user.check.value').empty

    local au = vim.api.nvim_create_autocmd

    local group = vim.api.nvim_create_augroup('UserAssocs', { clear = true })

    local retab = function()
        vim.cmd('%retab')
    end

    ---@type AuRepeatEvents[]
    local aus = {
        {
            events = { 'BufNewFile', 'BufReadPre' },
            opts_tbl = {
                { pattern = '.spacemacs', callback = ft('lisp'), group = group },
                { pattern = '.clangd', callback = ft('yaml'), group = group },
            },
        },
        {
            events = { 'FileType' },
            opts_tbl = {
                {
                    pattern = 'c',
                    callback = function()
                        local optset = vim.api.nvim_set_option_value
                        local opts = {
                            ['ts'] = 2,
                            ['sts'] = 2,
                            ['sw'] = 2,
                            ['et'] = true,
                        }

                        for option, val in next, opts do
                            optset(option, val, { buf = 0 })
                        end
                    end,
                },
                {
                    pattern = 'cpp',
                    callback = function()
                        local optset = vim.api.nvim_set_option_value
                        local opts = {
                            ['ts'] = 2,
                            ['sts'] = 2,
                            ['sw'] = 2,
                            ['et'] = true,
                        }

                        for option, val in next, opts do
                            optset(option, val, { buf = 0 })
                        end
                    end,
                },
                {
                    pattern = 'markdown',
                    callback = function()
                        local optset = vim.api.nvim_set_option_value
                        local opts = {
                            ['ts'] = 2,
                            ['sts'] = 2,
                            ['sw'] = 2,
                            ['et'] = true,
                        }

                        for option, val in next, opts do
                            optset(option, val, { buf = 0 })
                        end
                    end,
                },
            },
        },
    }

    local ok, _ = pcall(require, 'orgmode')

    if ok then
        table.insert(aus[1].opts_tbl, { pattern = '*.org', callback = ft('org'), group = group })
    end

    for _, v in next, aus do
        if not (is_str(v.events) or is_tbl(v.events)) or empty(v.events) then
            M.notify.notify('(user.assoc): Event type `' .. type(v.events) .. '` is neither string nor table', 'error')
            goto continue
        end

        if not is_tbl(v.opts_tbl) or empty(v.opts_tbl) then
            M.notify.notify('(user.assoc): Event options in a non-table or an empty one', 'error')
            goto continue
        end

        for _, o in next, v.opts_tbl do
            if not is_tbl(o) or empty(o) then
                M.notify.notify('(user.assoc): Event option is not a table or an empty one', 'error')
                goto continue
            end

            if not is_nil(o.pattern) and (not is_str(o.pattern) or empty(o.pattern)) then
                M.notify.notify('(user.assoc): Pattern is not a string or is an empty one', 'error')
                goto continue
            end

            if not is_fun(o.callback) then
                M.notify.notify('(user.assoc): Callback is not a function', 'error')
                goto continue
            end

            au(v.events, o)
        end

        ::continue::
    end
end

function M.displace_letter(c, direction, cycle)
    local Value = require('user.check.value')
    direction = (Value.is_str(direction) and vim.tbl_contains({ 'next', 'prev' }, direction)) and direction or 'next'
    cycle = Value.is_bool(cycle) and cycle or false

    if c == '' then
        return 'a'
    end

    local lower_map_next = {
        a = 'b',
        b = 'c',
        c = 'd',
        d = 'e',
        e = 'f',
        f = 'g',
        g = 'h',
        h = 'i',
        i = 'j',
        j = 'k',
        k = 'l',
        l = 'm',
        m = 'n',
        n = 'o',
        o = 'p',
        p = 'q',
        q = 'r',
        r = 's',
        s = 't',
        t = 'u',
        u = 'v',
        v = 'w',
        w = 'x',
        x = 'y',
        y = 'z',
        z = cycle and 'a' or 'A',
    }
    local lower_map_prev = {
        a = cycle and 'z' or 'Z',
        b = 'a',
        c = 'b',
        d = 'c',
        e = 'd',
        f = 'e',
        g = 'f',
        h = 'g',
        i = 'h',
        j = 'i',
        k = 'j',
        l = 'k',
        m = 'l',
        n = 'm',
        o = 'n',
        p = 'o',
        q = 'p',
        r = 'q',
        s = 'r',
        t = 's',
        u = 't',
        v = 'u',
        w = 'v',
        x = 'w',
        y = 'x',
        z = 'y',
    }
    local upper_map_prev = {
        A = cycle and 'Z' or 'z',
        B = 'A',
        C = 'B',
        D = 'C',
        E = 'D',
        F = 'E',
        G = 'F',
        H = 'G',
        I = 'H',
        J = 'I',
        K = 'J',
        L = 'K',
        M = 'L',
        N = 'M',
        O = 'N',
        P = 'O',
        Q = 'P',
        R = 'Q',
        S = 'R',
        T = 'S',
        U = 'T',
        V = 'U',
        W = 'V',
        X = 'W',
        Y = 'X',
        Z = 'Y',
    }
    local upper_map_next = {
        A = 'B',
        B = 'C',
        C = 'D',
        D = 'E',
        E = 'F',
        F = 'G',
        G = 'H',
        H = 'I',
        I = 'J',
        J = 'K',
        K = 'L',
        L = 'M',
        M = 'N',
        N = 'O',
        O = 'P',
        P = 'Q',
        Q = 'R',
        R = 'S',
        S = 'T',
        T = 'U',
        U = 'V',
        V = 'W',
        W = 'X',
        X = 'Y',
        Y = 'Z',
        Z = cycle and 'A' or 'a',
    }

    if direction == 'next' and Value.fields(c, lower_map_next) then
        return lower_map_next[c]
    elseif direction == 'next' and Value.fields(c, upper_map_next) then
        return upper_map_next[c]
    elseif direction == 'prev' and Value.fields(c, lower_map_prev) then
        return lower_map_prev[c]
    elseif direction == 'prev' and Value.fields(c, upper_map_prev) then
        return upper_map_prev[c]
    end

    error('(user.util.displace_letter): Invalid argument')
end

return M
