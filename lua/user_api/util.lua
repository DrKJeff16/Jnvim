local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO

local curr_buf = vim.api.nvim_get_current_buf
local curr_win = vim.api.nvim_get_current_win
local optset = vim.api.nvim_set_option_value
local optget = vim.api.nvim_get_option_value
local augroup = vim.api.nvim_create_augroup
local buf_lines = vim.api.nvim_buf_get_lines
local win_cursor = vim.api.nvim_win_get_cursor
local in_tbl = vim.tbl_contains
local in_list = vim.list_contains
local validate = vim.validate

---@class User.Util
local Util = {}

Util.notify = require('user_api.util.notify')
Util.au = require('user_api.util.autocmd')
Util.string = require('user_api.util.string')

---@return boolean
function Util.has_words_before()
    local line, col = (unpack or table.unpack)(win_cursor(curr_win()))
    return col ~= 0 and buf_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---@param s string[]|string
---@param bufnr? integer
---@return table<string, any> res
function Util.get_opts_tbl(s, bufnr)
    validate('s', s, { 'string', 'table' }, false, 'string[]|string')
    validate('bufnr', bufnr, 'number', true, 'integer')

    local Value = require('user_api.check.value')
    local type_not_empty = Value.type_not_empty

    bufnr = bufnr or curr_buf()

    ---@type table<string, any>
    local res = {}

    ---@cast s string
    if type_not_empty('string', s) then
        res[s] = optget(s, { buf = bufnr })
    end

    ---@cast s string[]
    if type_not_empty('table', s) then
        for _, opt in ipairs(s) do
            res[opt] = Util.get_opts_tbl(opt, bufnr)
        end
    end

    return res
end

---@param T table<string, any>
---@param steps? integer
---@param direction? 'l'|'r'
---@return table<string, any> res
function Util.mv_tbl_values(T, steps, direction)
    validate('T', T, 'table', false, 'table<string, any>')
    validate('steps', steps, 'number', true, 'integer')
    validate('direction', direction, 'string', true, "'l'|'r'")

    steps = steps > 0 and steps or 1
    direction = (direction ~= nil and in_list({ 'l', 'r' }, direction)) and direction or 'r'

    ---@class DirectionFuns
    local direction_funcs = {

        ---@param t table<string, any>
        ---@return table<string, any> res
        r = function(t)
            ---@type string[]
            local keys = vim.tbl_keys(t)
            table.sort(keys)
            local len = #keys

            ---@type table<string, any>
            local res = {}

            for i, v in ipairs(keys) do
                res[v] = t[keys[i == 1 and len or (i - 1)]]
            end

            return res
        end,

        ---@param t table<string, any>
        ---@return table<string, any> res
        l = function(t)
            ---@type string[]
            local keys = vim.tbl_keys(t)
            table.sort(keys)
            local len = #keys

            ---@type table<string, any>
            local res = {}

            for i, v in ipairs(keys) do
                res[v] = t[keys[i == len and 1 or (i + 1)]]
            end

            return res
        end,
    }

    local res, func = T, direction_funcs[direction]
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
    if vim.fn.has('nvim-0.11') then
        validate('x', x, 'boolean', false)
        validate('y', y, 'boolean', false)
    else
        validate({
            x = { x, 'boolean' },
            y = { y, 'boolean' },
        })
    end

    return (x and not y) or (not x and y)
end

---@param T table<string, any>
---@param fields string|integer|(string|integer)[]
---@return table<string, any> T
function Util.strip_fields(T, fields)
    if vim.fn.has('nvim-0.11') then
        validate('T', T, 'table', false, 'table<string, any>')
        validate(
            'fields',
            fields,
            { 'string', 'number', 'table' },
            false,
            'string|integer|(string|integer)[]'
        )
    else
        validate({
            T = { T, 'table' },
            fields = { fields, { 'string', 'number', 'table' } },
        })
    end

    local Value = require('user_api.check.value')
    local is_str = Value.is_str
    local field = Value.fields
    local type_not_empty = Value.type_not_empty

    ---@cast fields string
    if is_str(fields) then
        if not (type_not_empty('string', fields) and field(fields, T)) then
            return T
        end

        for k, _ in pairs(T) do
            if k == fields then
                T[k] = nil
            end
        end

        return T
    end

    for k, _ in pairs(T) do
        ---@cast fields (string|integer)[]
        if in_tbl(fields, k) then
            T[k] = nil
        end
    end

    return T
end

---@param T table<string, any>
---@param values any[]
---@param max_instances? integer
---@return table<string, any> res
function Util.strip_values(T, values, max_instances)
    validate('T', T, 'table', false, 'table<string, any>')
    validate('values', values, 'table', false, 'any[]')
    validate('max_instances', max_instances, 'table', true, 'integer')

    local Value = require('user_api.check.value')

    local type_not_empty = Value.type_not_empty
    local is_int = Value.is_int

    if not (type_not_empty('table', T) or type_not_empty('table', values)) then
        error('(user_api.util.strip_values): Empty tables as args!', ERROR)
    end

    max_instances = max_instances or 0

    ---@type table<string, any>, integer
    local res, count = {}, 0

    for k, v in pairs(T) do
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
    validate('s', s, 'string', true)
    validate('bufnr', bufnr, 'number', true, 'integer')

    s = s or ''
    bufnr = bufnr or curr_buf()

    return function()
        optset('ft', s, { buf = bufnr })
    end
end

---@param bufnr? integer
---@return string
function Util.bt_get(bufnr)
    validate('bufnr', bufnr, 'number', true, 'integer')
    bufnr = bufnr or curr_buf()

    return optget('bt', { buf = bufnr })
end

---@param bufnr? integer
---@return string
function Util.ft_get(bufnr)
    validate('bufnr', bufnr, 'number', true, 'integer')
    bufnr = bufnr or curr_buf()

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

                        for opt, val in pairs(opt_dict) do
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

                        for opt, val in pairs(opt_dict) do
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
            events = { 'TextYankPost' },
            opts_tbl = {
                {
                    pattern = '*',
                    group = group,
                    callback = function()
                        vim.hl.on_yank({ higroup = 'Visual', timeout = 300 })
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
                        local desc = require('user_api.maps').desc
                        local notify = Util.notify.notify

                        local bt = Util.bt_get(ev.buf)
                        local ft = Util.ft_get(ev.buf)

                        ---@type vim.api.keyset.option
                        local win_opts = { win = curr_win() }

                        ---@type vim.api.keyset.option
                        local buf_opts = { buf = ev.buf }

                        if ft == 'lazy' then
                            optset('signcolumn', 'no', win_opts)
                            optset('number', false, win_opts)
                            return
                        end

                        if bt == 'help' or ft == 'help' then
                            optset('signcolumn', 'no', win_opts)
                            optset('number', false, win_opts)
                            optset('wrap', true, win_opts)
                            optset('colorcolumn', '', win_opts)

                            vim.keymap.set('n', 'q', vim.cmd.bdelete, { buffer = ev.buf })

                            local fn = vim.schedule_wrap(function()
                                vim.cmd.wincmd('=')
                                vim.cmd.noh()
                            end)

                            fn()
                            return
                        end

                        if not optget('modifiable', buf_opts) then
                            return
                        end

                        if ft == 'lua' and executable('stylua') then
                            Keymaps({
                                n = {
                                    ['<leader><C-l>'] = {
                                        function()
                                            ---@diagnostic disable-next-line:param-type-mismatch
                                            local ok = pcall(vim.cmd, 'silent! !stylua %')

                                            if not ok then
                                                return
                                            end

                                            notify('Formatted successfully!', INFO, {
                                                title = 'StyLua',
                                                animate = true,
                                                timeout = 200,
                                                hide_from_history = true,
                                            })
                                        end,
                                        desc('Format With `stylua`'),
                                    },
                                },
                            }, ev.buf)
                        end

                        if ft == 'python' and executable('isort') then
                            Keymaps({
                                n = {
                                    ['<leader><C-l>'] = {
                                        function()
                                            ---@diagnostic disable-next-line:param-type-mismatch
                                            local ok = pcall(vim.cmd, 'silent! !isort %')

                                            if not ok then
                                                return
                                            end

                                            notify('Formatted successfully!', INFO, {
                                                title = 'isort',
                                                animate = true,
                                                timeout = 200,
                                                hide_from_history = true,
                                            })
                                        end,
                                        desc('Format With `isort`'),
                                    },
                                },
                            }, ev.buf)
                        end
                    end,
                },
            },
        },
    }

    local ok = pcall(require, 'orgmode')

    if ok then
        table.insert(AUS[1].opts_tbl, {
            group = group,
            pattern = '*.org',
            callback = function(ev)
                Util.ft_set('org', ev.buf)()
            end,
        })
    end

    ---@type AuRepeatEvents[]
    Util.au.created = vim.tbl_deep_extend('keep', Util.au.created or {}, AUS)

    for _, t in ipairs(Util.au.created) do
        au_repeated_events(t)
    end
end

---@param c string
---@param direction? 'next'|'prev'
---@return string
function Util.displace_letter(c, direction)
    validate('c', c, 'string', false)
    validate('direction', direction, 'string', true, "'next'|'prev'")
    local Value = require('user_api.check.value')
    local A = Util.string.alphabet

    local fields = Value.fields
    local is_str = Value.is_str
    local mv = Util.mv_tbl_values

    direction = (is_str(direction) and in_list({ 'next', 'prev' }, direction)) and direction
        or 'next'

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

    ---@cast data string
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

    ---@cast data table
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

---@type User.Util
local M = setmetatable({}, { __index = Util })

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
