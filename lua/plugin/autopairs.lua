local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local ft_get = Util.ft_get

if not exists('nvim-autopairs') then
    User.deregister_plugin('plugin.autopairs')
    return
end

local AP = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local ts_conds = require('nvim-autopairs.ts-conds')
local Cond = require('nvim-autopairs.conds')

AP.setup({
    ---Control if auto-pairs should be enabled when attaching to a specific buffer
    --- ---
    ---@param bufnr integer
    enabled = function(bufnr)
        return ft_get(bufnr) ~= 'help'
    end,

    disable_filetype = {
        'TelescopePrompt',
        'spectre_panel',
        'snacks_picker_input',
    },

    disable_in_macro = true, -- disable when recording or executing a macro
    disable_in_visualblock = false, -- disable when insert after visual block mode
    disable_in_replace_mode = true,
    ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
    enable_moveright = true,
    enable_afterquote = true, -- add bracket pairs after quote
    enable_check_bracket_line = false, --- check bracket in same line
    enable_bracket_in_quote = true, --
    enable_abbr = false, -- trigger abbreviation
    break_undo = true, -- switch for basic rule break undo sequence
    check_ts = true,
    ts_config = {
        lua = { 'string' },
    },
    map_cr = true,
    map_bs = true, -- map the <BS> key
    map_c_h = false, -- Map the <C-h> key to delete a pair
    map_c_w = false, -- map <c-w> to delete a pair if possible
})

---@class BracketsSpec
local brackets = {
    { '(', ')' },
    { '[', ']' },
    { '{', '}' },
}

local Rules = {
    -- you can use regex
    -- press u1234 => u1234number
    Rule('u%d%d%d%d$', 'number', 'lua'):use_regex(true),

    -- Rule('%', '%', 'lua'):with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
    -- Rule('$', '$', 'lua'):with_pair(ts_conds.is_not_ts_node({ 'function' })),

    Rule('$', '$', { 'tex', 'latex' })
        -- don't add a pair if the next character is %
        :with_pair(
            Cond.not_after_regex('%%')
        )
        -- don't add a pair if  the previous character is xxx
        :with_pair(
            Cond.not_before_regex('xxx', 3)
        )
        -- don't move right when repeat character
        :with_move(Cond.none())
        -- don't delete if the next character is xx
        :with_del(Cond.not_after_regex('xx'))
        -- disable adding a newline when you press <cr>
        :with_cr(Cond.none()),

    Rule('$$', '$$', { 'tex', 'latex' }):with_pair(function(opts)
        print(vim.inspect(opts))
        if opts.line == 'aa $$' then
            -- don't add pair on that line
            return false
        end
    end),

    Rule('x%d%d%d%d$', 'number', 'lua'):use_regex(true, '<Tab>'):replace_endpair(function(opts)
        -- print(vim.inspect(opts))
        return opts.prev_char:sub(#opts.prev_char - 3, #opts.prev_char)
    end),

    Rule(' ', ' ')
        -- Pair will only occur if the conditional function returns true
        :with_pair(
            function(opts)
                -- We are checking if we are inserting a space in (), [], or {}
                local pair = opts.line:sub(opts.col - 1, opts.col)
                return vim.tbl_contains({
                    brackets[1][1] .. brackets[1][2],
                    brackets[2][1] .. brackets[2][2],
                    brackets[3][1] .. brackets[3][2],
                }, pair)
            end
        )
        :with_move(Cond.none())
        :with_cr(Cond.none())
        -- We only want to delete the pair of spaces when the cursor is as such: ( | )
        :with_del(
            function(opts)
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local context = opts.line:sub(col - 1, col + 2)
                return vim.tbl_contains({
                    brackets[1][1] .. '  ' .. brackets[1][2],
                    brackets[2][1] .. '  ' .. brackets[2][2],
                    brackets[3][1] .. '  ' .. brackets[3][2],
                }, context)
            end
        ),
    Rule('<', '>', {
        -- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
        -- so that it doesn't conflict with nvim-ts-autotag
        '-html',
        '-markdown',
        '-javascriptreact',
        '-typescriptreact',
    }):with_pair(
        -- regex will make it so that it will auto-pair on
        -- `a<` but not `a <`
        -- The `:?:?` part makes it also
        -- work on Rust generics like `some_func::<T>()`
        Cond.before_regex('%a+:?:?$', 3)
    ):with_move(function(opts)
        return opts.char == '>'
    end),

    Rule('{', '},', 'lua'):with_pair(ts_conds.is_ts_node({ 'table_constructor' })),
    Rule("'", "',", 'lua'):with_pair(ts_conds.is_ts_node({ 'table_constructor' })),
    Rule('"', '",', 'lua'):with_pair(ts_conds.is_ts_node({ 'table_constructor' })),
}

for _, bracket in next, brackets do
    table.insert(
        Rules,
        -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
        Rule(bracket[1] .. ' ', ' ' .. bracket[2])
            :with_pair(Cond.none())
            :with_move(function(opts)
                return opts.char == bracket[2]
            end)
            :with_del(Cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(
                function(_)
                    return '<C-c>2xi<CR><C-c>O'
                end
            )
    )
end

for _, punct in next, { ',', ';' } do
    table.insert(
        Rules,
        Rule('', punct)
            :with_move(function(opts)
                return opts.char == punct
            end)
            :with_pair(function()
                return false
            end)
            :with_del(function()
                return false
            end)
            :with_cr(function()
                return false
            end)
            :use_key(punct)
    )
end

AP.add_rules(Rules)

User.register_plugin('plugin.autopairs')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
