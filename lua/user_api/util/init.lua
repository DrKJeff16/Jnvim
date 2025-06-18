---@diagnostic disable:missing-fields

---@module 'user_api.types.user.util'

local curr_buf = vim.api.nvim_get_current_buf
local optset = vim.api.nvim_set_option_value
local optget = vim.api.nvim_get_option_value
local in_tbl = vim.tbl_contains

local ERROR = vim.log.levels.ERROR

---@type User.Util
local Util = {}

Util.notify = require('user_api.util.notify')
Util.au = require('user_api.util.autocmd')
Util.string = require('user_api.util.string')

---@return boolean
function Util.has_words_before()
    local buf_lines = vim.api.nvim_buf_get_lines
    local win_cursor = vim.api.nvim_win_get_cursor
    local curr_win = vim.api.nvim_get_current_win

    unpack = unpack or table.unpack
    local line, col = unpack(win_cursor(curr_win()))
    return col ~= 0 and buf_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---@param self User.Util
---@param s string|string[]
---@param bufnr? integer
---@return table<string, any>|table
function Util:opt_get(s, bufnr)
    local Value = require('user_api.check.value')

    local is_int = Value.is_int
    local type_not_empty = Value.type_not_empty
    local single_type_tbl = Value.single_type_tbl

    bufnr = is_int(bufnr) and bufnr or curr_buf()

    ---@type table<string, any>|table
    local res = {}

    if type_not_empty('string', s) then
        res[s] = optget(s, { buf = bufnr })
    end

    if type_not_empty('table', s) and single_type_tbl('string', s) then
        for _, opt in next, s do
            res[opt] = self:opt_get(opt, bufnr)
        end
    end

    return res
end

---@param s string
---@param val any
---@param bufnr? integer
function Util.opt_set(s, val, bufnr)
    local is_int = require('user_api.check.value').is_int

    bufnr = is_int(bufnr) and bufnr or curr_buf()

    optset(s, val, { buf = bufnr })
end

---@param T table<string|integer, any>
---@param steps? integer
---@param direction? 'l'|'r'
---@return table<string|integer, any> res
function Util.mv_tbl_values(T, steps, direction)
    local Value = require('user_api.check.value')

    local is_int = Value.is_int
    local type_not_empty = Value.type_not_empty
    local notify = Util.notify.notify

    if not type_not_empty('table', T) then
        notify("Input isn't a table, or it is empty", ERROR, {
            title = '(user_api.util.mv_tbl_values)',
            animate = true,
            hide_from_history = false,
            timeout = 2500,
        })
    end

    steps = (is_int(steps) and steps > 0) and steps or 1
    direction = (type_not_empty('string', direction) and in_tbl({ 'l', 'r' }, direction))
            and direction
        or 'r'

    ---@type DirectionFuns
    local direction_funcs = {

        ---@type DirectionFun
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

        ---@type DirectionFun
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

    local func = direction_funcs[direction]

    while steps > 0 do
        res = func(res)
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

    if not is_bool({ x, y }, true) then
        Util.notify.notify('An argument is not of boolean type', 'error', {
            hide_from_history = false,
            timeout = 2250,
            title = '(user_api.util.xor)',
            animate = true,
        })
        return false
    end

    return (x and not y) or (not x and y)
end

---@param T table<string|integer, any>
---@param fields string|integer|(string|integer)[]
---@return table<string|integer, any> res
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

        return res
    end

    for k, v in next, T do
        if not in_tbl(fields, k) then
            res[k] = v
        end
    end

    return res
end

---@param T table<string|integer, any>
---@param values any[]
---@param max_instances? integer
---@return table<string|integer, any> res
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

    ---@type table<string|integer, any>
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

    return function() Util.opt_set('ft', s, bufnr) end
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
---@return table, ...
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

function Util:assoc()
    local au_repeated_events = self.au.au_repeated_events

    local group = vim.api.nvim_create_augroup('UserAssocs', { clear = false })

    ---@type AuRepeatEvents[]
    local AUS = {
        { -- NOTE: Keep this as first element for `orgmode` addition
            events = { 'BufNewFile', 'BufReadPre' },
            opts_tbl = {
                { pattern = '.spacemacs', callback = self.ft_set('lisp'), group = group },
                { pattern = '.clangd', callback = self.ft_set('yaml'), group = group },
                { pattern = '*.norg', callback = self.ft_set('norg'), group = group },
            },
        },
        {
            events = { 'BufEnter', 'WinEnter', 'FileType' },
            opts_tbl = {
                {
                    group = group,
                    callback = function()
                        local bufnr = curr_buf()
                        if not (self.ft_get(bufnr) == 'help' and self.bt_get(bufnr) == 'help') then
                            return
                        end

                        vim.schedule(function()
                            vim.api.nvim_set_option_value('signcolumn', 'no', { scope = 'local' })
                            vim.cmd.wincmd('=')
                            vim.cmd.noh()
                        end)
                    end,
                },
                {
                    pattern = { 'c', 'cpp' },
                    group = group,
                    callback = function()
                        local buf_opts = {
                            tabstop = 2,
                            softtabstop = 2,
                            shiftwidth = 2,
                            autoindent = true,
                            smartindent = true,
                            expandtab = true,
                            copyindent = false,
                            preserveindent = false,
                        }

                        for option, val in next, buf_opts do
                            Util.opt_set(option, val, curr_buf())
                        end
                    end,
                },
                {
                    pattern = 'lua',
                    group = group,
                    callback = function()
                        local executable = require('user_api.check.exists').executable
                        local buf = curr_buf()

                        -- Make sure the buffer is modifiable
                        if not optget('modifiable', { buf = buf }) or not executable('stylua') then
                            self.notify.notify('No stylua???')
                            return
                        end

                        local map_dict = require('user_api.maps').map_dict
                        local desc = require('user_api.maps.kmap').desc

                        map_dict({
                            ['<leader><C-l>'] = {
                                ':silent !stylua %<CR>',
                                desc('Format With `stylua`', true, buf),
                            },
                        }, 'wk.register', false, 'n', buf)
                    end,
                },
                {
                    pattern = 'python',
                    group = group,
                    callback = function()
                        local executable = require('user_api.check.exists').executable
                        local buf = curr_buf()

                        -- Make sure the buffer is modifiable
                        if not (optget('modifiable', { buf = buf }) and executable('isort')) then
                            return
                        end

                        local map_dict = require('user_api.maps').map_dict
                        local desc = require('user_api.maps.kmap').desc

                        map_dict({
                            ['<leader><C-l>'] = {
                                ':silent !isort %<CR>',
                                desc('Format With `isort`', true, buf),
                            },
                        }, 'wk.register', false, 'n', buf)
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
            callback = self.ft_set('org'),
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

    local LOWER = vim.deepcopy(A.lower_map)
    local UPPER = vim.deepcopy(A.upper_map)

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
---@return string|table
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
        if not vim.tbl_contains(res, v) then
            res[k] = v
        end
    end

    return res
end

---@param O? table
---@return table|User.Util
function Util.new(O)
    local is_tbl = require('user_api.check.value').is_tbl
    O = is_tbl(O) and O or {}

    return setmetatable(O, { __index = Util })
end

return Util

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
