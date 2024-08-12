---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

require('user_api.types.user.util')

---@param T table|table<string|integer, any>
---@param steps? integer
---@param direction? 'l'|'r'
---@return table|table<string|integer, any>
local function mv_tbl_values(T, steps, direction)
    local is_tbl = require('user_api.check.value').is_tbl
    local is_str = require('user_api.check.value').is_str
    local is_int = require('user_api.check.value').is_int
    local empty = require('user_api.check.value').empty

    if not is_tbl(T) then
        error("(user_api.util.mv_tbl_values): Input isn't a table")
    end

    if empty(T) then
        return T
    end

    ---@cast T table<(string|integer), any>

    steps = (is_int(steps) and steps > 0) and steps or 1
    direction = (is_str(direction) and vim.tbl_contains({ 'l', 'r' }, direction)) and direction
        or 'r'

    local direction_funcs = {
        ---@param t table<string|integer, any>
        ---@return table<string|integer, any> res
        r = function(t)
            ---@type (string|integer)[]
            local keys = vim.tbl_keys(t)
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
            local n_keys = #keys

            ---@type table<string|integer, any>
            local res = {}

            for i, v in next, keys do
                if i == n_keys then
                    res[v] = t[keys[1]]
                else
                    res[v] = t[keys[i + 1]]
                end
            end

            return res
        end,
    }

    local res = T

    while steps > 0 and steps > -1 do
        res = direction_funcs[direction](res)
        steps = steps - 1
    end

    return res
end

---@param x boolean
---@param y boolean
---@return boolean
local function xor(x, y)
    if not require('user_api.check.value').is_bool({ x, y }, true) then
        error('(user_api.util.xor): An argument is not of boolean type')
    end

    return (x and not y) or (not x and y)
end

---@param T table<string|integer, any>
---@param fields string|table
---@return table<string|integer, any> res
local function strip_fields(T, fields)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl
    local is_str = Value.is_str
    local is_int = Value.is_int
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

---@param T table<string|integer, any>
---@param values any[]
---@param max_instances? integer
---@return table<string|integer, any> res
local function strip_values(T, values, max_instances)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl
    local is_nil = Value.is_nil
    local is_str = Value.is_str
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

---@param s string
---@param bufnr? integer
---@return fun()
local function ft_set(s, bufnr)
    local Value = require('user_api.check.value')

    local is_int = Value.is_int
    local is_str = Value.is_str

    bufnr = is_int(bufnr) and bufnr or 0

    return function()
        if is_str(s) then
            vim.api.nvim_set_option_value('ft', s, { buf = bufnr })
        end
    end
end

---@param bufnr? integer
---@return string
local function ft_get(bufnr)
    bufnr = require('user_api.check.value').is_int(bufnr) and bufnr or 0

    return vim.api.nvim_get_option_value('ft', { buf = bufnr })
end

local function assoc()
    local Value = require('user_api.check.value')

    local is_nil = Value.is_nil
    local is_fun = Value.is_fun
    local is_tbl = Value.is_tbl
    local is_str = Value.is_str
    local empty = Value.empty

    local au_repeated_events = require('user_api.util.autocmd').au_repeated_events

    local group = vim.api.nvim_create_augroup('UserAssocs', { clear = true })

    local retab = function() vim.cmd('%retab') end

    ---@type AuRepeatEvents[]
    local aus = {
        { -- NOTE: Keep this as first element for `orgmode` addition
            events = { 'BufNewFile', 'BufReadPre' },
            opts_tbl = {
                { pattern = '.spacemacs', callback = ft_set('lisp'), group = group },
                { pattern = '.clangd', callback = ft_set('yaml'), group = group },
            },
        },
        {
            events = { 'BufRead', 'WinEnter', 'BufReadPost' },
            opts_tbl = {
                {
                    pattern = '*.txt',
                    group = group,
                    callback = function()
                        local buftype = vim.api.nvim_get_option_value(
                            'bt',
                            { buf = vim.api.nvim_get_current_buf() }
                        )

                        if ft_get() ~= 'help' or buftype ~= 'help' then
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
                        local buftype = vim.api.nvim_get_option_value(
                            'bt',
                            { buf = vim.api.nvim_get_current_buf() }
                        )
                        if buftype ~= 'help' then
                            return
                        end

                        vim.cmd.wincmd('=')
                    end,
                },
                {
                    pattern = 'c',
                    group = group,
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
                    group = group,
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
                    group = group,
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
                    pattern = 'lua',
                    group = group,
                    callback = function()
                        if require('user_api.check.exists').executable('stylua') then
                            local map_dict = require('user_api.maps').map_dict
                            local WK = require('user_api.maps.wk')
                            local desc = require('user_api.maps.kmap').desc

                            map_dict({
                                ['<leader><C-l>'] = {
                                    ':silent !stylua %<CR>',
                                    desc('Format with Stylua', true, 0),
                                },
                            }, 'wk.register', false, 'n', 0)
                        end
                    end,
                },
            },
        },
    }

    local ok, _ = pcall(require, 'orgmode')

    if ok then
        table.insert(
            aus[1].opts_tbl,
            { pattern = '*.org', callback = ft_set('org'), group = group }
        )
    end

    local notify = require('user_api.util.notify').notify

    for _, T in next, aus do
        au_repeated_events(T)
    end
end

---@param c string
---@param direction? 'next'|'prev'
---@param cycle? boolean
---@return string
local function displace_letter(c, direction, cycle)
    local Value = require('user_api.check.value')
    direction = (Value.is_str(direction) and vim.tbl_contains({ 'next', 'prev' }, direction))
            and direction
        or 'next'
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

    error('(user_api.util.displace_letter): Invalid argument')
end

---@type User.Util
local M = {
    notify = require('user_api.util.notify'),
    au = require('user_api.util.autocmd'),

    assoc = assoc,
    xor = xor,
    strip_fields = strip_fields,
    strip_values = strip_values,
    displace_letter = displace_letter,
    ft_get = ft_get,
    ft_set = ft_set,
    mv_tbl_values = mv_tbl_values,
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
