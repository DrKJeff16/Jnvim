---@alias AnyDict table<string, any>

---@alias DirectionFun fun(t: AnyDict): res: AnyDict

local curr_buf = vim.api.nvim_get_current_buf
local optset = vim.api.nvim_set_option_value
local optget = vim.api.nvim_get_option_value
local in_tbl = vim.tbl_contains

local augroup = vim.api.nvim_create_augroup

---@class User.Util
local Util = {}

Util.notify = require('user_api.util.notify')
Util.au = require('user_api.util.autocmd')
Util.string = require('user_api.util.string')
Util.error = require('user_api.util.error')

local ERROR = Util.error.ERROR
local INFO = Util.error.INFO

---@return boolean
function Util.has_words_before()
    local buf_lines = vim.api.nvim_buf_get_lines
    local win_cursor = vim.api.nvim_win_get_cursor
    local curr_win = vim.api.nvim_get_current_win

    local line, col = (unpack or table.unpack)(win_cursor(curr_win()))
    return col ~= 0 and buf_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---@param s string|string[]
---@param bufnr? integer
---@return AnyDict res
function Util.get_opts_tbl(s, bufnr)
    local Value = require('user_api.check.value')

    local is_int = Value.is_int
    local type_not_empty = Value.type_not_empty

    bufnr = is_int(bufnr) and bufnr or curr_buf()

    ---@type AnyDict
    local res = {}

    if type_not_empty('string', s) then
        res[s] = optget(s, { buf = bufnr })
    end

    if type_not_empty('table', s) then
        for _, opt in next, s do
            res[opt] = Util.get_opts_tbl(opt, bufnr)
        end
    end

    return res
end

---@param T AnyDict
---@param steps? integer
---@param direction? 'l'|'r'
---@return AnyDict res
function Util.mv_tbl_values(T, steps, direction)
    local notify = Util.notify.notify

    if T == nil or type(T) ~= 'table' then
        notify("Input isn't a table, or it is empty", ERROR, {
            title = '(user_api.util.mv_tbl_values)',
            animate = true,
            hide_from_history = false,
            timeout = 2500,
        })
    end

    steps = steps > 0 and steps or 1
    direction = (direction ~= nil and in_tbl({ 'l', 'r' }, direction)) and direction or 'r'

    ---@class DirectionFuns
    local direction_funcs = {

        ---@type DirectionFun
        r = function(t)
            ---@type string[]
            local keys = vim.tbl_keys(t)
            table.sort(keys)
            local len = #keys

            ---@type AnyDict
            local res = {}

            for i, v in next, keys do
                if i == 1 then
                    res[v] = t[keys[len]]
                else
                    res[v] = t[keys[i - 1]]
                end
            end

            return res
        end,

        ---@type DirectionFun
        l = function(t)
            ---@type string[]
            local keys = vim.tbl_keys(t)
            table.sort(keys)
            local len = #keys

            ---@type AnyDict
            local res = {}

            for i, v in next, keys do
                if i == len then
                    res[v] = t[keys[1]]
                elseif i < len and i > 0 then
                    res[v] = t[keys[i + 1]]
                end
            end

            return res
        end,
    }

    local res = T
    local func = direction_funcs[direction]

    while steps > 0 do
        res = func(res)

        ---WARN: DO NOT DELETE THE LINE BELOW
        steps = steps - 1
    end

    return res
end

---@param x boolean
---@param y boolean
---@return boolean
function Util.xor(x, y)
    local Value = require('user_api.check.value')

    local is_bool = Value.is_bool
    local notify = Util.notify.notify

    if not is_bool({ x, y }, true) then
        notify('An argument is not of boolean type', 'error', {
            title = '(user_api.util.xor)',
            animate = true,
            timeout = 2250,
            hide_from_history = false,
        })
        return false
    end

    return (x and not y) or (not x and y)
end

---@param T AnyDict
---@param fields string|integer|(string|integer)[]
---@return AnyDict res
function Util.strip_fields(T, fields)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local field = Value.fields
    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', T) then
        error('(user_api.util.strip_fields): Argument is not a table', ERROR)
    end

    if not (type_not_empty('string', fields) or type_not_empty('table', fields)) then
        return T
    end

    ---@type AnyDict
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

        return res
    end

    for k, v in next, T do
        if not in_tbl(fields, k) then
            res[k] = v
        end
    end

    return res
end

---@param T AnyDict
---@param values any[]
---@param max_instances? integer
---@return AnyDict res
function Util.strip_values(T, values, max_instances)
    local Value = require('user_api.check.value')

    local type_not_empty = Value.type_not_empty
    local is_int = Value.is_int
    local notify = Util.notify.notify

    if not (type_not_empty('table', T) or type_not_empty('table', values)) then
        notify('Not a table', ERROR, {
            title = '(user_api.util.strip_values)',
            animate = true,
            hide_from_history = false,
            timeout = 1750,
        })
    end

    max_instances = is_int(max_instances) and max_instances or 0

    ---@type AnyDict
    local res = {}
    local count = 0

    for k, v in next, T do
        -- Both arguments can't be true simultaneously
        if Util.xor((max_instances == 0), (max_instances ~= 0 and max_instances > count)) then
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

---@param s? string
---@param bufnr? integer
---@return fun()
function Util.ft_set(s, bufnr)
    local Value = require('user_api.check.value')

    local is_int = Value.is_int
    local is_str = Value.is_str

    s = is_str(s) and s or ''
    bufnr = is_int(bufnr) and bufnr or curr_buf()

    return function()
        optset('ft', s, { buf = bufnr })
    end
end

---@param bufnr? integer
---@return string
function Util.bt_get(bufnr)
    local is_int = require('user_api.check.value').is_int

    bufnr = is_int(bufnr) and bufnr or curr_buf()

    return optget('bt', { buf = bufnr })
end

---@param bufnr? integer
---@return string
function Util.ft_get(bufnr)
    local is_int = require('user_api.check.value').is_int

    bufnr = is_int(bufnr) and bufnr or curr_buf()

    return optget('ft', { buf = bufnr })
end

---@param T table
---@param V any
---@return table
---@return ...
function Util.pop_values(T, V)
    local idx = 0

    for i, v in next, T do
        if v == V then
            idx = i
            break
        end
    end

    if idx < 1 or idx > #T then
        return T, nil
    end

    local val = table.remove(T, idx)

    return T, val
end

function Util.setup_autocmd()
    local au_repeated_events = Util.au.au_repeated_events
    local ft_set = Util.ft_set

    local group = augroup('User.AU', { clear = true })

    ---@type AuRepeatEvents[]
    local AUS = {
        -- NOTE: Keep this as first element for `orgmode` addition
        {
            events = { 'BufCreate', 'BufAdd', 'BufNew', 'BufNewFile', 'BufRead' },
            opts_tbl = {
                {
                    group = group,
                    pattern = '.spacemacs',
                    callback = function(ev)
                        ft_set('lisp', ev.buf)()
                    end,
                },
                {
                    group = group,
                    pattern = '*.el',
                    callback = function(ev)
                        ft_set('lisp', ev.buf)()
                    end,
                },
                {
                    group = group,
                    pattern = '.clangd',
                    callback = function(ev)
                        ft_set('yaml', ev.buf)()
                    end,
                },
                {
                    group = group,
                    pattern = '*.norg',
                    callback = function(ev)
                        ft_set('norg', ev.buf)()
                    end,
                },
                {
                    group = group,
                    pattern = { '*.c', '*.h' },
                    callback = function(ev)
                        ---@type vim.api.keyset.option
                        local setopt_opts = { buf = ev.buf }
                        local opt_dict = {
                            tabstop = 2,
                            shiftwidth = 2,
                            softtabstop = 2,
                            expandtab = true,
                            autoindent = true,
                            filetype = 'c',
                        }

                        for opt, val in next, opt_dict do
                            optset(opt, val, setopt_opts)
                        end
                    end,
                },
                {
                    group = group,
                    pattern = {
                        '*.C',
                        '*.H',
                        '*.c++',
                        '*.cc',
                        '*.cpp',
                        '*.cxx',
                        '*.h++',
                        '*.hh',
                        '*.hpp',
                        '*.html',
                        '*.hxx',
                        '*.md',
                        '*.mdx',
                        '*.yaml',
                        '*.yml',
                    },
                    callback = function(ev)
                        ---@type vim.api.keyset.option
                        local setopt_opts = { buf = ev.buf }
                        local opt_dict = {
                            tabstop = 2,
                            shiftwidth = 2,
                            softtabstop = 2,
                            expandtab = true,
                            autoindent = true,
                        }

                        for opt, val in next, opt_dict do
                            optset(opt, val, setopt_opts)
                        end
                    end,
                },
            },
        },
        {
            events = { 'FileType' },
            opts_tbl = {
                {
                    pattern = 'checkhealth',
                    group = group,
                    callback = function()
                        ---@type vim.api.keyset.option
                        local O = { scope = 'local' }
                        optset('wrap', true, O)
                        optset('number', false, O)
                        optset('signcolumn', 'no', O)
                    end,
                },
            },
        },
        {
            events = { 'BufEnter', 'WinEnter', 'BufWinEnter' },
            opts_tbl = {
                {
                    group = group,
                    callback = function(ev)
                        local Keymaps = require('user_api.config.keymaps')
                        local executable = require('user_api.check.exists').executable
                        local desc = require('user_api.maps.kmap').desc
                        local notify = Util.notify.notify

                        local buf = ev.buf

                        local bt = Util.bt_get(buf)
                        local ft = Util.ft_get(buf)

                        ---@type vim.api.keyset.option
                        local O = { scope = 'local' }

                        if ft == 'lazy' then
                            optset('signcolumn', 'no', O)
                            optset('number', false, O)
                            return
                        end

                        if bt == 'help' or ft == 'help' then
                            vim.schedule(function()
                                optset('signcolumn', 'no', O)
                                optset('number', false, O)
                                optset('wrap', true, O)

                                vim.cmd.wincmd('=')
                                vim.cmd.noh()
                            end)

                            return
                        end

                        if not optget('modifiable', O) then
                            return
                        end

                        if ft == 'lua' and executable('stylua') then
                            Keymaps({
                                n = {
                                    ['<leader><C-l>'] = {
                                        function()
                                            ---@diagnostic disable-next-line:param-type-mismatch
                                            local ok, _ = pcall(vim.cmd, 'silent! !stylua %')

                                            if not ok then
                                                return
                                            end

                                            notify('Formatted successfully!', INFO, {
                                                title = 'StyLua',
                                                animate = true,
                                                timeout = 350,
                                                hide_from_history = true,
                                            })
                                        end,
                                        desc('Format With `stylua`'),
                                    },
                                },
                            }, buf)
                        end

                        if ft == 'python' and executable('isort') then
                            Keymaps({
                                n = {
                                    ['<leader><C-l>'] = {
                                        function()
                                            ---@diagnostic disable-next-line:param-type-mismatch
                                            local ok, _ = pcall(vim.cmd, 'silent! !isort %')

                                            if not ok then
                                                return
                                            end

                                            notify('Formatted successfully!', INFO, {
                                                title = 'isort',
                                                animate = true,
                                                timeout = 350,
                                                hide_from_history = true,
                                            })
                                        end,
                                        desc('Format With `isort`'),
                                    },
                                },
                            }, buf)
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
            callback = function(ev)
                Util.ft_set('org', ev.buf)()
            end,
        })
    end

    Util.au.created = vim.tbl_deep_extend('keep', Util.au.created or {}, AUS)

    for _, t in next, Util.au.created do
        au_repeated_events(t)
    end
end

---@param c string
---@param direction? 'next'|'prev'
---@param cycle? boolean
---@return string
function Util.displace_letter(c, direction, cycle)
    local Value = require('user_api.check.value')
    local A = Util.string.alphabet

    local fields = Value.fields
    local is_str = Value.is_str
    local is_bool = Value.is_bool
    local mv = Util.mv_tbl_values

    direction = (is_str(direction) and in_tbl({ 'next', 'prev' }, direction)) and direction
        or 'next'
    cycle = is_bool(cycle) and cycle or false

    if c == '' then
        return 'a'
    end

    -- NOTE: Copy the tables from the alphabet field
    local LOWER, UPPER = vim.deepcopy(A.lower_map), vim.deepcopy(A.upper_map)

    ---@type string
    local res = ''

    if direction == 'prev' and fields(c, LOWER) then
        res = mv(LOWER, 1, 'r')[c]
    elseif direction == 'next' and fields(c, LOWER) then
        res = mv(LOWER, 1, 'l')[c]
    elseif direction == 'prev' and fields(c, UPPER) then
        res = mv(UPPER, 1, 'r')[c]
    elseif direction == 'next' and fields(c, UPPER) then
        res = mv(UPPER, 1, 'l')[c]
    end

    assert(res ~= '', string.format('(user_api.util.displace_letter): Invalid argument `%s`\n', c))

    return res
end

---@param data string|table
---@return string|table res
function Util.discard_dups(data)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local type_not_empty = Value.type_not_empty
    local notify = Util.notify.notify

    if not (type_not_empty('string', data) or type_not_empty('table', data)) then
        notify('Input is not valid!', 'error', {
            animate = true,
            hide_from_history = false,
            timeout = 2750,
            title = '(user_api.util.discard_dups)',
        })

        return data
    end

    ---@type string|table
    local res

    if is_str(data) then
        res = data:sub(1, 1)

        local i = 2

        while i < data:len() do
            local c = data:sub(i, i)
            if not res:match(c) then
                res = res .. c
            end
            i = i + 1
        end

        return res
    end

    ---@type table
    res = {}

    for k, v in next, data do
        if not in_tbl(res, v) then
            res[k] = v
        end
    end

    return res
end

---@param T table
---@return table
function Util.reverse_tbl(T)
    local Value = require('user_api.check.value')

    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', T) then
        error('(user_api.util.reverse_tbl): Empty or non-existant table', ERROR)
    end

    local len = #T

    for i = 1, math.floor(len / 2), 1 do
        T[i], T[len - i + 1] = T[len - i + 1], T[i]
    end

    return T
end

---@param O? table
---@return table|User.Util|fun(msg: string)
function Util.new(O)
    local is_tbl = require('user_api.check.value').is_tbl
    O = is_tbl(O) and O or {}

    return setmetatable(O, { __index = Util })
end

return Util.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
