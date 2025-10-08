---@module 'lazy'

local in_list = vim.list_contains

---Control if auto-pairs should be enabled when
---attaching to a specific buffer.
--- ---
---@param bufnr integer
---@return boolean
local function enable(bufnr)
    local EXCEPT_FT = {
        'TelescopePrompt',
        'TelescopeResults',
        'help',
        'lazy',
        'man',
        'minimap',
        'notify',
        'packer',
        'qf',
        'snacks_picker_input',
        'spectre_panel',
    }
    local EXCEPT_BT = {
        'help',
        'nofile',
        'nowrite',
        'prompt',
        'quickfix',
        'terminal',
    }
    local ft = require('user_api.util').ft_get(bufnr)
    local bt = require('user_api.util').bt_get(bufnr)

    return not (in_list(EXCEPT_FT, ft) or in_list(EXCEPT_BT, bt))
end

---@type LazySpec
return {
    'windwp/nvim-autopairs',
    lazy = true,
    event = 'InsertEnter',
    version = false,
    dependencies = {
        {
            'RRethy/nvim-treesitter-endwise',
            lazy = true,
            event = 'InsertEnter',
            version = false,
            dependencies = { 'nvim-treesitter/nvim-treesitter' },
        },
    },
    config = function()
        local AP = require('nvim-autopairs')
        local Rule = require('nvim-autopairs.rule')
        local ts_conds = require('nvim-autopairs.ts-conds')
        local cond = require('nvim-autopairs.conds')
        local ts_node = ts_conds.is_ts_node

        AP.setup({
            enabled = enable,
            disable_filetype = {
                'TelescopePrompt',
                'snacks_picker_input',
                'spectre_panel',
            },
            disable_in_macro = true, -- Disable when recording or executing a macro
            disable_in_visualblock = false, --- Disable when insert after visual block mode
            disable_in_replace_mode = true,
            ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
            enable_moveright = true,
            enable_afterquote = true, --- Add bracket pairs after quote
            enable_check_bracket_line = false, --- Check bracket in same line
            enable_bracket_in_quote = true, --
            enable_abbr = false, --- Trigger abbreviation
            break_undo = true, --- Switch for basic rule break undo sequence
            check_ts = true,
            ts_config = { lua = { 'string' } },
            map_cr = true, --- Map the `<CR>` key
            map_bs = true, --- Map the `<BS>` key
            map_c_h = false, --- Map the `<C-h>` key to delete a pair
            map_c_w = false, --- Map `<C-w>` to delete a pair if possible
        })

        local joined_bracks = { '()', '[]', '{}' }
        local spaced_bracks = { '(  )', '[  ]', '{  }' }
        local bracks = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
        local Rules = { ---@type Rule[]
            Rule('$', '$', { 'tex', 'latex' })
                --- Don't add a pair if the next character is %
                :with_pair(
                    cond.not_after_regex('%%')
                )
                --- Don't add a pair if  the previous character is xxx
                :with_pair(
                    cond.not_before_regex('xxx', 3)
                )
                --- Don't move right when repeat character
                :with_move(cond.none())
                --- Don't delete if the next character is xx
                :with_del(
                    cond.not_after_regex('xx')
                )
                --- Disable adding a newline when you press <CR>
                :with_cr(
                    cond.none()
                ),

            Rule('$$', '$$', { 'tex', 'latex' }):with_pair(function(opts)
                if opts.line == 'aa $$' then
                    return false --- don't add pair on that line
                end
            end),

            Rule(' ', ' ')
                :with_pair( --- Pair will only occur if the conditional function returns true
                    function(opts)
                        --- We are checking if we are inserting a space in `()`, `[]`, or `{}`
                        local pair = opts.line:sub(opts.col - 1, opts.col)
                        return in_list(joined_bracks, pair)
                    end
                )
                :with_move(cond.none())
                :with_cr(cond.none())
                ---We only want to delete the pair of spaces when the cursor is as such: `( | )`
                :with_del(
                    function(opts)
                        local col = vim.api.nvim_win_get_cursor(0)[2]
                        local context = opts.line:sub(col - 1, col + 2)
                        return in_list(spaced_bracks, context)
                    end
                ),

            Rule('<', '>', {
                --- If you use nvim-ts-autotag, you may want to
                --- exclude these filetypes from this rule
                --- so that it doesn't conflict with `nvim-ts-autotag`
                '-html',
                '-markdown',
                '-javascriptreact',
                '-typescriptreact',
            }):with_pair(
                --- Regex will make it so that it will auto-pair on
                --- `a<` but not `a <`.
                --- The `:?:?` part makes it also
                --- work on Rust generics like `some_func::<T>()`
                cond.before_regex('%a+:?:?$', 3)
            ):with_move(function(opts)
                return opts.char == '>'
            end),

            Rule('{', '},', 'lua'):with_pair(ts_node({ 'table_constructor' })),
            Rule("'", "',", 'lua'):with_pair(ts_node({ 'table_constructor' })),
            Rule('"', '",', 'lua'):with_pair(ts_node({ 'table_constructor' })),
        }
        for _, bracket in next, bracks do
            table.insert(
                Rules,
                --- Each of these rules is for a pair with left-side `'( '`
                --- and right-side `' )'` for each bracket type
                Rule(bracket[1] .. ' ', ' ' .. bracket[2])
                    :with_pair(cond.none())
                    :with_move(function(opts)
                        return opts.char == bracket[2]
                    end)
                    :with_del(cond.none())
                    :use_key(bracket[2])
                    --- Removes the trailing whitespace that can occur without this
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
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
