local fmt = string.format

local ERROR = vim.log.levels.ERROR

local validate = vim.validate
local in_tbl = vim.tbl_contains

---@class User.Util.String
local String = {}

---@class User.Util.String.Alphabet
String.alphabet = {
    upper_list = {
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
    },
    lower_list = {
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
    },
    upper_map = {
        A = 'A',
        B = 'B',
        C = 'C',
        D = 'D',
        E = 'E',
        F = 'F',
        G = 'G',
        H = 'H',
        I = 'I',
        J = 'J',
        K = 'K',
        L = 'L',
        M = 'M',
        N = 'N',
        O = 'O',
        P = 'P',
        Q = 'Q',
        R = 'R',
        S = 'S',
        T = 'T',
        U = 'U',
        V = 'V',
        W = 'W',
        X = 'X',
        Y = 'Y',
        Z = 'Z',
    },
    lower_map = {
        a = 'a',
        b = 'b',
        c = 'c',
        d = 'd',
        e = 'e',
        f = 'f',
        g = 'g',
        h = 'h',
        i = 'i',
        j = 'j',
        k = 'k',
        l = 'l',
        m = 'm',
        n = 'n',
        o = 'o',
        p = 'p',
        q = 'q',
        r = 'r',
        s = 's',
        t = 't',
        u = 'u',
        v = 'v',
        w = 'w',
        x = 'x',
        y = 'y',
        z = 'z',
    },
    vowels = {
        upper_list = { 'A', 'E', 'I', 'O', 'U' },
        lower_list = { 'a', 'e', 'i', 'o', 'u' },
        upper_map = {
            A = 'A',
            E = 'E',
            I = 'I',
            O = 'O',
            U = 'U',
        },
        lower_map = {
            a = 'a',
            e = 'e',
            i = 'i',
            o = 'o',
            u = 'u',
        },
    },
}

---@class User.Util.String.Digits
String.digits = {
    all = {
        ['0'] = '0',
        ['1'] = '1',
        ['2'] = '2',
        ['3'] = '3',
        ['4'] = '4',
        ['5'] = '5',
        ['6'] = '6',
        ['7'] = '7',
        ['8'] = '8',
        ['9'] = '9',
    },
    odd_list = { '1', '3', '5', '7', '9' },
    even_list = { '0', '2', '4', '6', '8' },
    even_map = {
        ['0'] = '0',
        ['2'] = '2',
        ['4'] = '4',
        ['6'] = '6',
        ['8'] = '8',
    },
    odd_map = {
        ['1'] = '1',
        ['3'] = '3',
        ['5'] = '5',
        ['7'] = '7',
        ['9'] = '9',
    },
}

---@param str string
---@param use_dot? boolean
---@param triggers? string[]
---@return string new_str
function String.capitalize(str, use_dot, triggers)
    validate('str', str, 'string', false)
    validate('use_dot', use_dot, 'boolean', true)
    validate('triggers', triggers, 'table', true, 'string[]')

    local Value = require('user_api.check.value')
    local type_not_empty = Value.type_not_empty

    if str == '' then
        return str
    end

    use_dot = use_dot ~= nil and use_dot or false
    triggers = type_not_empty('table', triggers) and triggers or { ' ', '' }

    if not in_tbl(triggers, ' ') then
        table.insert(triggers, ' ')
    end
    if not in_tbl(triggers, '') then
        table.insert(triggers, '')
    end

    local strlen = str:len()
    local prev_char, new_str, i = '', '', 1
    local dot = true

    while i <= strlen do
        local char = str:sub(i, i)

        if char == char:lower() and in_tbl(triggers, prev_char) then
            char = dot and char:upper() or char:lower()

            if dot then
                dot = false
            end
        else
            char = char:lower()
        end

        if use_dot and not dot then
            dot = char == '.'
        elseif not use_dot then
            dot = true
        end

        new_str = fmt('%s%s', new_str, char)
        prev_char = char

        i = i + 1
    end

    return new_str
end

---@param str string
---@param target string
---@param new string
---@return string
function String.replace(str, target, new)
    validate('str', str, 'string', false)
    validate('target', target, 'string', false)
    validate('new', new, 'string', false)

    if in_tbl({ str:len(), target:len(), new:len() }, 0) or new == target then
        return str
    end

    local new_str, len = '', str:len()

    for i = 1, len, 1 do
        local c = str:sub(i, i)

        c = c == target and new or c
        new_str = fmt('%s%s', new_str, c)
    end

    return new_str
end

---@type User.Util.String
local M = setmetatable({}, {
    __index = String,

    __newindex = function(_, _, _)
        error('User.Util.String table is Read-Only!', ERROR)
    end,
})

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
