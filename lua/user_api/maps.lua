local Value = require('user_api.check.value')
local Util = require('user_api.util')

local is_tbl = Value.is_tbl
local is_str = Value.is_str
local is_int = Value.is_int
local is_bool = Value.is_bool
local empty = Value.empty
local type_not_empty = Value.type_not_empty
local strip_fields = Util.strip_fields

local in_tbl = vim.tbl_contains

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }
local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN

---@class User.Maps
local Maps = {}

Maps.kmap = require('user_api.maps.kmap')
Maps.wk = require('user_api.maps.wk')

Maps.modes = MODES

---@param T string|string[]
---@param opts? User.Maps.Keymap.Opts
---@param mode? MapModes
---@param prefix? string
function Maps.nop(T, opts, mode, prefix)
    if not (is_str(T) or is_tbl(T)) then
        error('(user_api.maps.nop): Argument is neither a string nor a table')
    end

    local insp = inspect or vim.inspect

    mode = (is_str(mode) and in_tbl(MODES, mode)) and mode or 'n'

    if mode == 'i' then
        vim.notify(
            '(user_api.maps.nop): Refusing to NO-OP these keys in Insert mode: ' .. insp(T),
            WARN
        )
    end

    opts = is_tbl(opts) and opts or {}

    opts.silent = is_bool(opts.silent) and opts.silent or true

    if is_int(opts.buffer) then
        ---@type User.Maps.Keymap.Opts
        opts = strip_fields(opts, 'buffer')
    end

    prefix = is_str(prefix) and prefix or ''

    ---@type KeyMapFun
    local func = Maps.kmap[mode]

    if is_str(T) then
        func(prefix .. T, '<Nop>', opts)
        return
    end

    for _, v in next, T do
        func(prefix .. v, '<Nop>', opts)
    end
end

---@param T AllModeMaps|AllMaps
---@param map_func 'kmap'|'wk.register'
---@param dict_has_modes? boolean
---@param mode? MapModes
---@param bufnr? integer
function Maps.map_dict(T, map_func, dict_has_modes, mode, bufnr)
    if not (type_not_empty('table', T)) then
        error("(user_api.maps.map_dict): Keys either aren't table or table is empty", ERROR)
    end

    if (is_str(mode) and not in_tbl(MODES, mode)) or (is_tbl(mode) and empty(mode)) then
        mode = 'n'
    elseif type_not_empty('table', mode) then
        for _, v in next, mode do
            if not in_tbl(MODES, v) then
                error('(user_api.maps.map_dict): Bad modes table', ERROR)
            end
        end
    end

    local map_choices = { 'kmap', 'wk.register' }

    -- Choose `which-key` by default
    map_func = (is_str(map_func) and in_tbl(map_choices)) and map_func or 'wk.register'

    if not Maps.wk.available() then
        map_func = 'kmap'
    end

    mode = (is_str(mode) and in_tbl(MODES, mode)) and mode or 'n'
    dict_has_modes = is_bool(dict_has_modes) and dict_has_modes or false
    bufnr = is_int(bufnr) and bufnr or nil

    ---@type KeyMapFun
    local func

    if dict_has_modes then
        for mode_choice, t in next, T do
            if not in_tbl(MODES, mode_choice) then
                goto continue
            end

            if map_func == 'kmap' then
                ---@type KeyMapFun
                func = Maps.kmap[mode_choice]

                for lhs, v in next, t do
                    if not v[1] then
                        goto continue
                    end

                    v[2] = is_tbl(v[2]) and v[2] or {}

                    func(lhs, v[1], v[2])
                end
                goto continue
            end

            for lhs, v in next, t do
                local tbl = {}
                if is_str(lhs) then
                    table.insert(tbl, lhs)
                else
                    goto continue
                end

                if v[1] ~= nil then
                    table.insert(tbl, v[1])
                end

                tbl.mode = mode_choice

                if bufnr ~= nil then
                    tbl.buffer = bufnr
                end

                if is_str(v.group) then
                    tbl.group = v.group
                end

                if is_bool(v.hidden) then
                    tbl.hidden = v.hidden
                end

                if is_tbl(v[2]) then
                    if is_str(v[2].desc) then
                        tbl.desc = v[2].desc
                    end
                    if is_bool(v[2].expr) then
                        tbl.expr = v[2].expr
                    end
                    if is_bool(v[2].noremap) then
                        tbl.noremap = v[2].noremap
                    end
                    if is_bool(v[2].nowait) then
                        tbl.nowait = v[2].nowait
                    end
                    if is_bool(v[2].silent) then
                        tbl.silent = v[2].silent
                    end
                end

                require('which-key').add(tbl)

                ::continue::
            end

            ::continue::
        end
    elseif map_func == 'kmap' then
        ---@type KeyMapFun
        func = Maps.kmap[mode]

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

            if v[1] ~= nil then
                table.insert(tbl, v[1])
            end

            tbl.mode = mode

            if bufnr ~= nil then
                tbl.buffer = bufnr
            end

            if is_str(v.group) then
                tbl.group = v.group
            end

            if is_bool(v.hidden) then
                tbl.hidden = v.hidden
            end

            if is_tbl(v[2]) then
                if is_str(v[2].desc) then
                    tbl.desc = v[2].desc
                end
                if is_bool(v[2].expr) then
                    tbl.expr = v[2].expr
                end
                if is_bool(v[2].noremap) then
                    tbl.noremap = v[2].noremap
                end
                if is_bool(v[2].nowait) then
                    tbl.nowait = v[2].nowait
                end
                if is_bool(v[2].silent) then
                    tbl.silent = v[2].silent
                end
            end

            require('which-key').add(tbl)

            ::continue::
        end
    end
end

return Maps

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
