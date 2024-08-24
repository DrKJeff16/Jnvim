require('user_api.types.user.maps')

local Value = require('user_api.check.value')
local Util = require('user_api.util')

local is_nil = Value.is_nil
local is_tbl = Value.is_tbl
local is_fun = Value.is_fun
local is_str = Value.is_str
local is_int = Value.is_int
local is_bool = Value.is_bool
local empty = Value.empty
local field = Value.fields
local strip_fields = Util.strip_fields

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---@type User.Maps
---@diagnostic disable-next-line:missing-fields
local M = {}

M.kmap = require('user_api.maps.kmap')

M.wk = require('user_api.maps.wk')

M.modes = MODES

function M.nop(T, opts, mode, prefix)
    if not (is_str(T) or is_tbl(T)) then
        error('(user.maps.nop): Argument is neither a string nor a table')
    end

    mode = (is_str(mode) and vim.tbl_contains(MODES, mode)) and mode or 'n'
    if not vim.tbl_contains({ 'n', 'v' }, mode) then
        return
    end

    opts = is_tbl(opts) and opts or {}

    opts.silent = is_bool(opts.silent) and opts.silent or true

    if is_int(opts.buffer) then
        ---@type User.Maps.Keymap.Opts
        opts = strip_fields(opts, 'buffer')
    end

    prefix = is_str(prefix) and prefix or ''

    ---@type KeyMapFunction
    local func = M.kmap[mode]

    if is_str(T) then
        func(prefix .. T, '<Nop>', opts)
        return
    end

    for _, v in next, T do
        func(prefix .. v, '<Nop>', opts)
    end
end

function M.map_dict(T, map_func, dict_has_modes, mode, bufnr)
    if not (is_tbl(T) and not empty(T)) then
        error("(user.maps.map_dict): Keys either aren't table or table is empty")
    end
    if not is_str(map_func) or empty(map_func) then
        error('(user.maps.map_dict): `map_func` is not a string')
    end

    mode = (is_str(mode) and vim.tbl_contains(MODES, mode)) and mode or 'n'
    dict_has_modes = is_bool(dict_has_modes) and dict_has_modes or false
    bufnr = is_int(bufnr) and bufnr or nil

    local map_choices = {
        'kmap',
        'wk.register',
    }

    if not vim.tbl_contains(map_choices, map_func) or not M.wk.available() then
        map_func = 'kmap'
    end

    ---@type fun(...)
    local func

    if dict_has_modes then
        for mode_choice, t in next, T do
            if not vim.tbl_contains(MODES, mode_choice) then
                goto continue
            end

            if map_func == 'kmap' then
                ---@type KeyMapFunction
                func = M.kmap[mode_choice]

                for lhs, v in next, t do
                    v[2] = is_tbl(v[2]) and v[2] or {}

                    func(lhs, v[1], v[2])
                end
            else
                for lhs, v in next, t do
                    local tbl = {}
                    if is_str(lhs) then
                        table.insert(tbl, lhs)
                    else
                        goto continue
                    end

                    if not is_nil(v[1]) then
                        table.insert(tbl, v[1])
                    end

                    tbl.mode = mode_choice

                    if is_int(bufnr) then
                        tbl.buffer = bufnr
                    end

                    if is_str(v.group) then
                        tbl.group = v.group
                    end

                    if is_tbl(v[2]) and is_str(v[2].desc) then
                        tbl.desc = v[2].desc
                    end
                    if is_tbl(v[2]) and v[2].expr then
                        tbl.expr = v[2].expr
                    end
                    if is_tbl(v[2]) and v[2].expr then
                        tbl.noremap = v[2].noremap
                    end
                    if is_tbl(v[2]) and v[2].expr then
                        tbl.nowait = v[2].nowait
                    end

                    if not is_nil(v.hidden) then
                        tbl.hidden = v.hidden
                    end

                    require('which-key').add(tbl)

                    ::continue::
                end
            end

            ::continue::
        end
    elseif map_func == 'kmap' then
        ---@type KeyMapFunction
        func = M.kmap[mode]

        for lhs, v in next, T do
            v[2] = is_tbl(v[2]) and v[2] or {}

            func(lhs, v[1], v[2])
        end
    else
        for lhs, v in next, T do
            local tbl = {}
            if is_str(lhs) then
                table.insert(tbl, lhs)
            else
                goto continue
            end

            if not is_nil(v[1]) then
                table.insert(tbl, v[1])
            end

            tbl.mode = mode

            if not is_nil(bufnr) then
                tbl.buffer = bufnr
            end

            if is_str(v.group) then
                tbl.group = v.group
            end

            if is_tbl(v[2]) and is_str(v[2].desc) then
                tbl.desc = v[2].desc
            end
            if is_tbl(v[2]) and v[2].expr then
                tbl.expr = v[2].expr
            end
            if is_tbl(v[2]) and v[2].expr then
                tbl.noremap = v[2].noremap
            end
            if is_tbl(v[2]) and v[2].expr then
                tbl.nowait = v[2].nowait
            end

            if not is_nil(v.hidden) then
                tbl.hidden = v.hidden
            end

            require('which-key').add(tbl)

            ::continue::
        end
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
