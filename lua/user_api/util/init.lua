require('user_api.types.user.util')

local curr_buf = vim.api.nvim_get_current_buf
local optset = vim.api.nvim_set_option_value

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
        error("(user_api.util.mv_tbl_values): Input isn't a table")
    end

    if empty(T) then
        return T
    end

    steps = (is_int(steps) and steps > 0) and steps or 1
    direction = (is_str(direction) and vim.tbl_contains({ 'l', 'r' }, direction)) and direction
        or 'r'

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
        error('(user_api.util.xor): An argument is not of boolean type')
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
function M.strip_values(T, values, max_instances)
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
        if M.xor(max_instances == 0, max_instances ~= 0 and max_instances > count) then
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
function M.ft_set(s, bufnr)
    local Value = require('user_api.check.value')

    local is_int = Value.is_int
    local is_str = Value.is_str

    bufnr = is_int(bufnr) and bufnr or curr_buf()

    return function()
        if is_str(s) then
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
    local Value = require('user_api.check.value')

    local is_nil = Value.is_nil
    local is_fun = Value.is_fun
    local is_tbl = Value.is_tbl
    local is_str = Value.is_str
    local empty = Value.empty
    local au_repeated_events = M.au.au_repeated_events

    local function retab() vim.cmd('%retab') end

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
                            not vim.tbl_contains({
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
                        if not is_nil(vim.g.installed_a_vim) and vim.g.installed_a_vim == 1 then
                            return
                        end

                        local wk_avail = require('user_api.maps.wk').available
                        local desc = require('user_api.maps.kmap').desc
                        local map_dict = require('user_api.maps').map_dict

                        local buf_opts = {
                            ts = 2,
                            sts = 2,
                            sw = 2,
                            ai = true,
                            si = true,
                            et = true,
                        }

                        for option, val in next, buf_opts do
                            optset(option, val, { buf = curr_buf() })
                        end

                        ---@type KeyMapDict
                        local Keys = {
                            ['<leader><C-h>s'] = {
                                ':A<CR>',
                                desc('Cycle Header/Source', true, 0),
                            },
                            ['<leader><C-h>x'] = {
                                ':AS<CR>',
                                desc('Horizontal Cycle Header/Source', true, 0),
                            },
                            ['<leader><C-h>v'] = {
                                ':AV<CR>',
                                desc('Vertical Cycle Header/Source', true, 0),
                            },
                            ['<leader><C-h>t'] = {
                                ':AT<CR>',
                                desc('Tab Cycle Header/Source', true, 0),
                            },
                            ['<leader><C-h>S'] = {
                                ':IH<CR>',
                                desc('Cycle Header/Source (Cursor)', true, 0),
                            },
                            ['<leader><C-h>X'] = {
                                ':IHS<CR>',
                                desc('Horizontal Cycle Header/Source (Cursor)', true, 0),
                            },
                            ['<leader><C-h>V'] = {
                                ':IHV<CR>',
                                desc('Vertical Cycle Header/Source (Cursor)', true, 0),
                            },
                            ['<leader><C-h>T'] = {
                                ':IHT<CR>',
                                desc('Tab Cycle Header/Source (Cursor)', true, 0),
                            },
                        }
                        ---@type RegKeysNamed
                        local Names = {
                            ['<leader><C-h>'] = { group = '+Header/Source Switch (C/C++)' },
                        }
                        if wk_avail() then
                            map_dict(Names, 'wk.register', false, 'n', 0)
                        end
                        map_dict(Keys, 'wk.register', false, 'n', 0)

                        -- Kill plugin-defined mappings
                        local nop = vim.api.nvim_buf_del_keymap

                        local i_del = {
                            'ih',
                            'is',
                            'ihn',
                        }

                        for _, lhs in next, i_del do
                            nop(0, 'i', lhs)
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
                        if require('user_api.check.exists').executable('stylua') then
                            local map_dict = require('user_api.maps').map_dict
                            local desc = require('user_api.maps.kmap').desc

                            map_dict({
                                ['<leader><C-l>'] = {
                                    ':silent !stylua %<CR>',
                                    desc('Format With `stylua`', true, 0),
                                },
                            }, 'wk.register', false, 'n', 0)
                        end
                    end,
                },
                {
                    pattern = 'python',
                    group = group,
                    callback = function()
                        if require('user_api.check.exists').executable('isort') then
                            local map_dict = require('user_api.maps').map_dict
                            local desc = require('user_api.maps.kmap').desc

                            map_dict({
                                ['<leader><C-l>'] = {
                                    ':silent !isort %<CR>',
                                    desc('Format With `isort`', true, 0),
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
            AUS[1].opts_tbl,
            { pattern = '*.org', callback = M.ft_set('org'), group = group }
        )
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
    local mv_tbl_values = M.mv_tbl_values

    direction = (is_str(direction) and vim.tbl_contains({ 'next', 'prev' }, direction))
            and direction
        or 'next'
    cycle = is_bool(cycle) and cycle or false

    if c == '' then
        return 'a'
    end

    local lower_next = vim.deepcopy(A.lower_map)
    local upper_next = vim.deepcopy(A.upper_map)
    local lower_prev = vim.deepcopy(A.lower_map)
    local upper_prev = vim.deepcopy(A.upper_map)

    if direction == 'next' and fields(c, lower_next) then
        return mv_tbl_values(lower_next, 1, 'l')[c]
    elseif direction == 'next' and fields(c, upper_next) then
        return mv_tbl_values(upper_next, 1, 'l')[c]
    elseif direction == 'prev' and fields(c, lower_prev) then
        return mv_tbl_values(lower_prev, 1, 'r')[c]
    elseif direction == 'prev' and fields(c, upper_prev) then
        return mv_tbl_values(upper_prev, 1, 'r')[c]
    end

    error('(user_api.util.displace_letter): Invalid argument `' .. c .. '`')
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
