---@module 'user_api.types.autopairs'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('nvim-autopairs') then
    return
end

local api = vim.api

local Ap = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local Conds = require('nvim-autopairs.conds')

local BPAIRS = {
    { '(', ')' },
    { '[', ']' },
    { '{', '}' },
    { '<', '>' },
}

local rule2 = function(a1, ins, a2, lang)
    Ap.add_rules({
        Rule(ins, ins, lang)
            :with_pair(
                function(opts) return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1) end
            )
            :with_move(Conds.none())
            :with_cr(Conds.none())
            :with_del(function(opts)
                local col = api.nvim_win_get_cursor(0)[2]
                local line = opts.line

                -- insert only works for #ins == 1 anyway
                return a1 .. ins .. ins .. a2 == line:sub(col - #a1 - #ins + 1, col + #ins + #a2)
            end),
    })
end

local Rules = {
    Rule(' ', ' ')
        :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
                BPAIRS[1][1] .. BPAIRS[1][2],
                BPAIRS[2][1] .. BPAIRS[2][2],
                BPAIRS[3][1] .. BPAIRS[3][2],
            }, pair)
        end)
        :with_move(Conds.none())
        :with_cr(Conds.none())
        :with_del(function(opts)
            local col = api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
                BPAIRS[1][1] .. '  ' .. BPAIRS[1][2],
                BPAIRS[2][1] .. '  ' .. BPAIRS[2][2],
                BPAIRS[3][1] .. '  ' .. BPAIRS[3][2],
            }, context)
        end),

    Rule('$', '$', { 'tex', 'latex' })
        -- don't add a pair if the next character is %
        :with_pair(
            Conds.not_after_regex('%%')
        )
        -- don't add a pair if the previous character is xxx
        :with_pair(
            Conds.not_before_regex('xxx', 3)
        )
        -- don't move right when repeat character
        :with_move(Conds.none())
        -- don't delete if the next character is xx
        :with_del(Conds.not_after_regex('xx'))
        -- disable adding a newline when you press <cr>
        :with_cr(Conds.none()),

    Rule('$$', '$$', 'tex'):with_pair(function(opts)
        print(vim.inspect(opts))
        if opts.line == 'aa $$' then
            -- don't add pair on that line
            return false
        end
    end),

    Rule('<', '>', { 'markdown', 'html', 'xml', 'xhtml' })
        :with_move(Conds.none())
        :with_del(Conds.not_after_regex('%s*/')),

    Rule('<', '>', { 'lua' })
        :with_pair(Conds.before_regex('--.*'))
        :with_move(Conds.none())
        :with_cr(Conds.none())
        :with_move(Conds.none()),

    Rule('<', '>', { 'c', 'cpp' })
        :with_pair(Conds.before_regex('%s*%#include%s*'))
        :with_cr(Conds.none())
        :with_move(Conds.none()),

    Rule('\\start(%w*) $', 'tex')
        :replace_endpair(function(opts)
            local beforeText = string.sub(opts.line, 0, opts.col)
            local _, _, match = beforeText:find('\\start(%w*)')
            if match and #match > 0 then
                return ' \\stop' .. match
            end
            return ''
        end)
        :with_move(Conds.none())
        :use_key('<space>')
        :use_regex(true),
}

for _, bracket in next, BPAIRS do
    table.insert(
        Rules,
        -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
        Rule(bracket[1] .. ' ', ' ' .. bracket[2])
            :with_pair(Conds.none())
            :with_move(function(opts) return opts.char == bracket[2] end)
            :with_del(Conds.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(
                function(_) return '<C-c>2xi<CR><C-c>O' end
            )
            :with_del(Conds.none())
    )
end

for _, punct in next, { ',', ';' } do
    table.insert(
        Rules,
        Rule('', punct)
            :with_move(function(opts) return opts.char == punct end)
            :with_pair(function() return false end)
            :with_del(function() return false end)
            :with_cr(function() return false end)
            :use_key(punct)
    )
end

Ap.add_rules(Rules)

rule2('(', ' ', ')')
rule2('[', ' ', ']', 'sh')
rule2('[[', ' ', ']]', 'sh')
rule2('{', ' ', '}', 'lua')

Ap.add_rules(require('nvim-autopairs.rules.endwise-lua'))

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
