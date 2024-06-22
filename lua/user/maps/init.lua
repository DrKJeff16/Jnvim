---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

require('user.types.user.maps')

local Check = require('user.check')
local Util = require('user.util')

local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_num = Check.value.is_num
local is_int = Check.value.is_int
local is_bool = Check.value.is_bool
local empty = Check.value.empty
local field = Check.value.fields
local strip_fields = Util.strip_fields

local kmap = vim.keymap.set
local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap

---@type Modes
local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---@type User.Maps
local M = {
    kmap = require('user.maps.kmap'),
    map = require('user.maps.map'),
    buf_map = require('user.maps.buf_map'),
    wk = require('user.maps.wk'),
    modes = MODES,
    nop = function(T, opts, mode, prefix)
        if not (is_str(T) or is_tbl(T)) then
            error('(user.maps.nop): Argument is neither a string nor a table')
        end

        mode = (is_str(mode) and vim.tbl_contains(MODES, mode)) and mode or 'n'
        if vim.tbl_contains({ 'i', 't', 'o', 'x' }, mode) then
            return
        end

        opts = is_tbl(opts) and opts or {}

        for _, v in next, { 'nowait', 'noremap' } do
            opts[v] = is_bool(opts[v]) and opts[v] or false
        end

        opts.silent = is_bool(opts.silent) and opts.silent or true

        if is_int(opts.buffer) then
            ---@type User.Maps.Keymap.Opts
            opts = strip_fields(opts, 'buffer')
        end

        prefix = is_str(prefix) and prefix or ''

        local Kmap = require('user.maps.kmap')

        if is_str(T) then
            kmap(mode, prefix .. T, '<Nop>', opts)
        else
            for _, v in next, T do
                kmap(mode, prefix .. v, '<Nop>', opts)
            end
        end
    end,
}

function M.map_dict(T, map_func, dict_has_modes, mode, bufnr)
    if not (is_tbl(T) and not empty(T)) then
        error("(user.maps.map_dict): Keys either aren't table or table is empty")
    end
    if not is_str(map_func) or empty(map_func) then
        error('(user.maps.map_dict): `map_func` is not a string')
    end

    if not (is_str(mode) and vim.tbl_contains(M.modes, mode)) then
        mode = 'n'
    end

    dict_has_modes = is_bool(dict_has_modes) and dict_has_modes or false

    bufnr = is_int(bufnr) and bufnr or nil

    local map_choices = {
        ['kmap'] = M.kmap,
        ['map'] = M.map,
        ['wk.register'] = M.wk.register,
    }

    if not field(map_func, map_choices) or (map_func == 'wk.register' and not M.wk.available()) then
        map_func = 'kmap'
    end

    if dict_has_modes then
        for mode_choice, t in next, T do
            if map_func == 'kmap' or map_func == 'map' then
                for lhs, v in next, t do
                    v[2] = is_tbl(v[2]) and v[2] or {}

                    map_choices[map_func][mode_choice](lhs, v[1], v[2])
                end
            else
                ---@type RegOpts
                local wk_opts = { mode = mode_choice }

                if not is_nil(bufnr) then
                    wk_opts.buffer = bufnr
                end

                map_choices[map_func](M.wk.convert_dict(t), wk_opts)
            end
        end
    elseif map_func == 'kmap' or map_func == 'map' then
        for lhs, v in next, T do
            v[2] = is_tbl(v[2]) and v[2] or {}

            map_choices[map_func][mode](lhs, v[1], v[2])
        end
    else
        ---@type RegOpts
        local wk_opts = { mode = mode }

        if not is_nil(bufnr) then
            wk_opts.buffer = bufnr
        end

        map_choices[map_func](M.wk.convert_dict(T), wk_opts)
    end
end

for _, key in next, { M.map, M.buf_map } do
    function key.desc(msg, silent, noremap, nowait, expr)
        return {
            desc = (is_str(msg) and not empty(msg)) and msg or 'Unnamed Key',
            silent = is_bool(silent) and silent or true,
            noremap = is_bool(noremap) and noremap or true,
            nowait = is_bool(nowait) and nowait or true,
            expr = is_bool(expr) and expr or false,
        }
    end
end

return M
