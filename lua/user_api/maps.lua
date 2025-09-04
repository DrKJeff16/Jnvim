---@module 'user_api.maps._meta'

local Value = require('user_api.check.value')
local Util = require('user_api.util')
local O = require('user_api.maps.objects')

local is_tbl = Value.is_tbl
local is_str = Value.is_str
local is_int = Value.is_int
local is_bool = Value.is_bool
local type_not_empty = Value.type_not_empty
local strip_fields = Util.strip_fields

local validate = vim.validate
local in_tbl = vim.tbl_contains

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }
local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN

---@type User.Maps
local Maps = {}

Maps.modes = MODES
Maps.keymap = require('user_api.maps.keymap')
Maps.wk = require('user_api.maps.wk')

function Maps.desc(desc, silent, bufnr, noremap, nowait, expr)
    validate('desc', desc, { 'string', 'nil' }, false, 'string|nil')

    if not type_not_empty('string', desc) then
        desc = 'Unnamed Key'
    end
    if silent == nil then
        silent = true
    end
    if noremap == nil then
        noremap = true
    end

    local res = O.new()

    res:add({
        desc = desc,
        silent = silent,
        noremap = noremap,
    })

    if nowait ~= nil then
        res:add({ nowait = nowait })
    end

    if expr ~= nil then
        res:add({ expr = expr })
    end

    if bufnr ~= nil then
        res:add({ buffer = bufnr })
    end

    return res
end

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
        ---@type User.Maps.Opts
        opts = strip_fields(opts, 'buffer')
    end

    prefix = is_str(prefix) and prefix or ''

    local func = Maps.keymap[mode]

    if is_str(T) then
        func(prefix .. T, '<Nop>', opts)
        return
    end

    for _, v in next, T do
        func(prefix .. v, '<Nop>', opts)
    end
end

function Maps.map_dict(T, map_func, has_modes, mode, bufnr)
    if not (type_not_empty('table', T)) then
        error("(user_api.maps.map_dict): Keys either aren't table or table is empty", ERROR)
    end

    if is_str(mode) and not in_tbl(MODES, mode) then
        mode = 'n'
    elseif type_not_empty('table', mode) then
        for _, v in next, mode do
            if not in_tbl(MODES, v) then
                error('(user_api.maps.map_dict): Bad modes table', ERROR)
            end
        end
    end

    local map_choices = { 'keymap', 'wk.register' }

    -- Choose `which-key` by default
    map_func = in_tbl(map_choices, map_func) and map_func or 'wk.register'

    if not Maps.wk.available() then
        map_func = 'keymap'
    end

    mode = (is_str(mode) and in_tbl(MODES, mode)) and mode or 'n'
    has_modes = is_bool(has_modes) and has_modes or false
    bufnr = is_int(bufnr) and bufnr or nil

    ---@type fun(lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts)
    local func

    if has_modes then
        local keymap_ran = false

        for mode_choice, t in next, T do
            if in_tbl(MODES, mode_choice) then
                if map_func == 'keymap' then
                    func = Maps.keymap[mode_choice]

                    for lhs, v in next, t do
                        v[2] = is_tbl(v[2]) and v[2] or {}

                        func(lhs, v[1], v[2])
                    end

                    keymap_ran = true
                end

                for lhs, v in next, t do
                    if keymap_ran then
                        break
                    end

                    if is_str(lhs) then
                        local tbl = {}

                        table.insert(tbl, lhs)

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

                        if not is_tbl(v[2]) then
                            v[2] = {}
                        end

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

                        require('which-key').add(tbl)
                    end
                end
            end
        end

        return
    end

    if map_func == 'keymap' then
        func = Maps.keymap[mode]

        for lhs, v in next, T do
            v[2] = is_tbl(v[2]) and v[2] or {}

            func(lhs, v[1], v[2])
        end

        return
    end

    for lhs, v in next, T do
        local tbl = {}
        if is_str(lhs) then
            table.insert(tbl, lhs)

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
        end
    end
end

return Maps

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
