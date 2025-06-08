---@diagnostic disable:missing-fields

---@module 'user_api.types.user.util'

---@type User.Util.String
local String = {}

String.alphabet = {}
String.alphabet.upper_list = {
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
}
String.alphabet.lower_list = {
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
}
String.alphabet.upper_map = {
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
}
String.alphabet.lower_map = {
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
}

String.alphabet.vowcals = {}
String.alphabet.vowcals.upper_list = {
    'A',
    'E',
    'I',
    'O',
    'U',
}
String.alphabet.vowcals.lower_list = {
    'a',
    'e',
    'i',
    'o',
    'u',
}
String.alphabet.vowcals.upper_map = {
    A = 'A',
    E = 'E',
    I = 'I',
    O = 'O',
    U = 'U',
}
String.alphabet.vowcals.lower_map = {
    a = 'a',
    e = 'e',
    i = 'i',
    o = 'o',
    u = 'u',
}

String.digits = {}
String.digits.all = {
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
}
String.digits.odd_list = {
    '1',
    '3',
    '5',
    '7',
    '9',
}
String.digits.even_list = {
    '0',
    '2',
    '4',
    '6',
    '8',
}
String.digits.even_map = {
    ['0'] = '0',
    ['2'] = '2',
    ['4'] = '4',
    ['6'] = '6',
    ['8'] = '8',
}
String.digits.odd_map = {
    ['1'] = '1',
    ['3'] = '3',
    ['5'] = '5',
    ['7'] = '7',
    ['9'] = '9',
}

---@param s string
---@param use_dot? boolean
---@param triggers? string[]
---@return string new_str
function String.capitalize(s, use_dot, triggers)
    if not require('user_api.check.value').is_str(s) then
        error('(user_api.util.string.capitalize): Input is not string')
    end

    if s == '' then
        return s
    end

    local has = vim.tbl_contains

    use_dot = require('user_api.check.value').is_bool(use_dot) and use_dot or false
    triggers = require('user_api.check.value').is_tbl(triggers) and triggers or { ' ', '' }
    if not has(triggers, ' ') then
        table.insert(triggers, ' ')
    end
    if not has(triggers, '') then
        table.insert(triggers, '')
    end

    local strlen = string.len(s)

    local prev_char = ''
    local new_str = ''
    local i = 1
    local dot = true

    while i <= strlen do
        local char = s:sub(i, i)

        if char == char:lower() and has(triggers, prev_char) then
            if dot then
                char = char:upper()
                dot = false
            else
                char = char:lower()
            end
        else
            char = char:lower()
        end

        if use_dot and not dot then
            dot = char == '.'
        elseif not use_dot then
            dot = true
        end

        new_str = new_str .. char

        prev_char = char
        i = i + 1
    end

    return new_str
end

return String

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
