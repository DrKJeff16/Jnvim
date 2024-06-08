---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

require('user.types.user.util')

---@type UserUtils
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

    ---@type UserMaps.Keymap.Opts
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
            events = { 'BufWritePre' },
            opts_tbl = {
                { pattern = '*', callback = retab, group = group },
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

return M
