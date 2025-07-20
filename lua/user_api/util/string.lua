---@diagnostic disable:missing-fields

---@class User.Util.String.Alphabet.Vowels
---@field upper_list { [1]: 'A', [2]: 'E', [3]: 'I', [4]: 'O', [5]: 'U' }
---@field lower_list { [1]: 'a', [2]: 'e', [3]: 'i', [4]: 'o', [5]: 'u' }
---@field upper_map { ['A']: 'A', ['E']: 'E', ['I']: 'I', ['O']: 'O', ['U']: 'U' }
---@field lower_map { ['a']: 'a', ['e']: 'e', ['i']: 'i', ['o']: 'o', ['u']: 'u' }

---@class User.Util.String.Alphabet.UpperMap
---@field A 'A'
---@field B 'B'
---@field C 'C'
---@field D 'D'
---@field E 'E'
---@field F 'F'
---@field G 'G'
---@field H 'H'
---@field I 'I'
---@field J 'J'
---@field K 'K'
---@field L 'L'
---@field M 'M'
---@field N 'N'
---@field O 'O'
---@field P 'P'
---@field Q 'Q'
---@field R 'R'
---@field S 'S'
---@field T 'T'
---@field U 'U'
---@field V 'V'
---@field W 'W'
---@field X 'X'
---@field Y 'Y'
---@field Z 'Z'

---@class User.Util.String.Alphabet.UpperList
---@field [1] 'A'
---@field [2] 'B'
---@field [3] 'C'
---@field [4] 'D'
---@field [5] 'E'
---@field [6] 'F'
---@field [7] 'G'
---@field [8] 'H'
---@field [9] 'I'
---@field [10] 'J'
---@field [11] 'K'
---@field [12] 'L'
---@field [13] 'M'
---@field [14] 'N'
---@field [15] 'O'
---@field [16] 'P'
---@field [17] 'Q'
---@field [18] 'R'
---@field [19] 'S'
---@field [20] 'T'
---@field [21] 'U'
---@field [22] 'V'
---@field [23] 'W'
---@field [24] 'X'
---@field [25] 'Y'
---@field [26] 'Z'

---@class User.Util.String.Alphabet.LowerList
---@field [1] 'a'
---@field [2] 'b'
---@field [3] 'c'
---@field [4] 'd'
---@field [5] 'e'
---@field [6] 'f'
---@field [7] 'g'
---@field [8] 'h'
---@field [9] 'i'
---@field [10] 'j'
---@field [11] 'k'
---@field [12] 'l'
---@field [13] 'm'
---@field [14] 'n'
---@field [15] 'o'
---@field [16] 'p'
---@field [17] 'q'
---@field [18] 'r'
---@field [19] 's'
---@field [20] 't'
---@field [21] 'u'
---@field [22] 'v'
---@field [23] 'w'
---@field [24] 'x'
---@field [25] 'y'
---@field [26] 'z'

---@class User.Util.String.Alphabet.LowerMap
---@field a 'a'
---@field b 'b'
---@field c 'c'
---@field d 'd'
---@field e 'e'
---@field f 'f'
---@field g 'g'
---@field h 'h'
---@field i 'i'
---@field j 'j'
---@field k 'k'
---@field l 'l'
---@field m 'm'
---@field n 'n'
---@field o 'o'
---@field p 'p'
---@field q 'q'
---@field r 'r'
---@field s 's'
---@field t 't'
---@field u 'u'
---@field v 'v'
---@field w 'w'
---@field x 'x'
---@field y 'y'
---@field z 'z'

---@class User.Util.String.Alphabet
---@field upper_list User.Util.String.Alphabet.UpperList
---@field lower_list User.Util.String.Alphabet.LowerList
---@field upper_map User.Util.String.Alphabet.UpperMap
---@field lower_map User.Util.String.Alphabet.LowerMap
---@field vowels User.Util.String.Alphabet.Vowels

---@class User.Util.String.Digits
---@field all { ['0']: '0', ['1']: '1', ['2']: '2', ['3']: '3', ['4']: '4', ['5']: '5', ['6']: '6', ['7']: '7', ['8']: '8', ['9']: '9' }
---@field odd_list { [1]: '1', [2]: '3', [3]: '5', [4]: '7', [5]: '9' }
---@field even_list { [1]: '0', [2]: '2', [3]: '4', [4]: '6', [5]: '8' }
---@field odd_map { ['1']: '1', ['3']: '3', ['5']: '5', ['7']: '7', ['9']: '9' }
---@field even_map { ['0']: '0', ['2']: '2', ['4']: '4', ['6']: '6', ['8']: '8' }

---@class User.Util.String
---@field alphabet User.Util.String.Alphabet
---@field digits User.Util.String.Digits
---@field capitalize fun(s: string, use_dot: boolean?, triggers: string[]?): (new_str: string)
---@field replace fun(str: string, target: string, new: string): string

---@type User.Util.String
local String = {
    alphabet = {
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
            upper_list = {
                'A',
                'E',
                'I',
                'O',
                'U',
            },
            lower_list = {
                'a',
                'e',
                'i',
                'o',
                'u',
            },
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
    },

    digits = {
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
        odd_list = {
            '1',
            '3',
            '5',
            '7',
            '9',
        },
        even_list = {
            '0',
            '2',
            '4',
            '6',
            '8',
        },
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
    },
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

---@param str string
---@param target string
---@param new string
---@return string
function String.replace(str, target, new)
    if string.len(str) == 0 then
        return str
    end
    if string.len(target) == 0 then
        return str
    end
    if string.len(new) == 0 or new == target then
        return str
    end

    ---@type string
    local new_str = ''
    local len = string.len(str)

    for i = 1, len, 1 do
        local c = str:sub(i, i)
        c = c == target and new or c

        new_str = new_str .. c
    end

    return new_str
end

return String

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
