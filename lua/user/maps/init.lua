---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

require('user.types.user.maps')

local Value = require('user.check.value')

local is_nil = Value.is_nil
local is_tbl = Value.is_tbl
local is_str = Value.is_str
local is_int = Value.is_int
local is_bool = Value.is_bool
local empty = Value.empty
local field = Value.fields
local strip_fields = require('user.util').strip_fields

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---@type User.Maps
local M = {
    modes = MODES,

    kmap = require('user.maps.kmap'),
    map = require('user.maps.map'),
    buf_map = require('user.maps.buf_map'),

    wk = require('user.maps.wk'),

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

        if is_str(T) then
            vim.keymap.set(mode, prefix .. T, '<Nop>', opts)
        else
            for _, v in next, T do
                vim.keymap.set(mode, prefix .. v, '<Nop>', opts)
            end
        end
    end,

    map_dict = function(T, map_func, dict_has_modes, mode, bufnr)
        if not (is_tbl(T) and not empty(T)) then
            error("(user.maps.map_dict): Keys either aren't table or table is empty")
        end
        if not is_str(map_func) or empty(map_func) then
            error('(user.maps.map_dict): `map_func` is not a string')
        end

        mode = (is_str(mode) and vim.tbl_contains(MODES, mode)) and mode or 'n'
        dict_has_modes = is_bool(dict_has_modes) and dict_has_modes or false
        bufnr = is_int(bufnr) and bufnr or nil

        local Kmap = require('user.maps.kmap')
        local Map = require('user.maps.map')
        local WK = require('user.maps.wk')

        local map_choices = {
            kmap = Kmap,
            map = Map,
            ['wk.register'] = WK.register,
        }

        if not field(map_func, map_choices) or (map_func == 'wk.register' and not WK.available()) then
            map_func = 'kmap'
        end

        local func

        if dict_has_modes then
            for mode_choice, t in next, T do
                if map_func == 'kmap' or map_func == 'map' then
                    ---@type ApiMapFunction|KeyMapFunction
                    func = map_choices[map_func][mode_choice]

                    for lhs, v in next, t do
                        v[2] = is_tbl(v[2]) and v[2] or {}

                        func(lhs, v[1], v[2])
                    end
                else
                    func = map_choices['wk.register']

                    ---@type RegOpts
                    local wk_opts = { mode = mode_choice }

                    if not is_nil(bufnr) then
                        wk_opts.buffer = bufnr
                    end

                    func(WK.convert_dict(t), wk_opts)
                end
            end
        elseif map_func == 'kmap' or map_func == 'map' then
            ---@type ApiMapFunction|KeyMapFunction
            func = map_choices[map_func][mode]

            for lhs, v in next, T do
                v[2] = is_tbl(v[2]) and v[2] or {}

                func(lhs, v[1], v[2])
            end
        else
            func = map_choices['wk.register']

            ---@type RegOpts
            local wk_opts = { mode = mode }

            if not is_nil(bufnr) then
                wk_opts.buffer = bufnr
            end

            func(WK.convert_dict(T), wk_opts)
        end
    end,
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
