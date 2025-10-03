---@module 'lazy'

---@type LazySpec
return {
    'julienvincent/nvim-paredit',
    version = false,
    config = function()
        require('nvim-paredit').setup({
            use_default_keys = false,
            filetypes = { 'clojure', 'fennel', 'scheme', 'lisp', 'janet' },
            languages = {
                clojure = { whitespace_chars = { ' ', ',' } },
                fennel = { whitekpace_chars = { ' ', ',' } },
            },
            -- This controls where the cursor is placed when performing slurp/barf operations
            --
            -- - "remain" - It will never change the cursor position, keeping it in the same place
            -- - "follow" - It will always place the cursor on the form edge that was moved
            -- - "auto"   - A combination of remain and follow, it will try keep the cursor in the original position
            --              unless doing so would result in the cursor no longer being within the original form. In
            --              this case it will place the cursor on the moved edge
            cursor_behaviour = 'auto', -- remain, follow, auto
            dragging = { auto_drag_pairs = true },
            indent = {
                enabled = true,
                indentor = require('nvim-paredit.indentation.native').indentor,
            },
            keys = {
                ['<localleader>@'] = {
                    require('nvim-paredit').unwrap.unwrap_form_under_cursor,
                    'Splice sexp',
                },
                ['<localleader>o'] = false,
                ['<localleader>O'] = false,
                ['<localleader>Po'] = { require('nvim-paredit').api.raise_form, 'Raise form' },
                ['<localleader>PO'] = { require('nvim-paredit').api.raise_element, 'Raise element' },
                ['>)'] = { require('nvim-paredit').api.slurp_forwards, 'Slurp forwards' },
                ['>('] = { require('nvim-paredit').api.barf_backwards, 'Barf backwards' },
                ['<)'] = { require('nvim-paredit').api.barf_forwards, 'Barf forwards' },
                ['<('] = { require('nvim-paredit').api.slurp_backwards, 'Slurp backwards' },
                ['>e'] = { require('nvim-paredit').api.drag_element_forwards, 'Drag element right' },
                ['<e'] = { require('nvim-paredit').api.drag_element_backwards, 'Drag element left' },
                ['>p'] = {
                    require('nvim-paredit').api.drag_pair_forwards,
                    'Drag element pairs right',
                },
                ['<p'] = {
                    require('nvim-paredit').api.drag_pair_backwards,
                    'Drag element pairs left',
                },
                ['>f'] = { require('nvim-paredit').api.drag_form_forwards, 'Drag form right' },
                ['<f'] = { require('nvim-paredit').api.drag_form_backwards, 'Drag form left' },
                E = {
                    require('nvim-paredit').api.move_to_next_element_tail,
                    'Jump to next element tail',
                    -- by default all keybindings are dot repeatable
                    repeatable = false,
                    mode = { 'n', 'x', 'o', 'v' },
                },
                W = {
                    require('nvim-paredit').api.move_to_next_element_head,
                    'Jump to next element head',
                    repeatable = false,
                    mode = { 'n', 'x', 'o', 'v' },
                },
                B = {
                    require('nvim-paredit').api.move_to_prev_element_head,
                    'Jump to previous element head',
                    repeatable = false,
                    mode = { 'n', 'x', 'o', 'v' },
                },
                gE = {
                    require('nvim-paredit').api.move_to_prev_element_tail,
                    'Jump to previous element tail',
                    repeatable = false,
                    mode = { 'n', 'x', 'o', 'v' },
                },
                ['('] = {
                    require('nvim-paredit').api.move_to_parent_form_start,
                    "Jump to parent form's head",
                    repeatable = false,
                    mode = { 'n', 'x', 'v' },
                },
                [')'] = {
                    require('nvim-paredit').api.move_to_parent_form_end,
                    "Jump to parent form's tail",
                    repeatable = false,
                    mode = { 'n', 'x', 'v' },
                },
                af = {
                    require('nvim-paredit').api.select_around_form,
                    'Around form',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
                ['if'] = {
                    require('nvim-paredit').api.select_in_form,
                    'In form',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
                aF = {
                    require('nvim-paredit').api.select_around_top_level_form,
                    'Around top level form',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
                iF = {
                    require('nvim-paredit').api.select_in_top_level_form,
                    'In top level form',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
                ae = {
                    require('nvim-paredit').api.select_element,
                    'Around element',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
                ie = {
                    require('nvim-paredit').api.select_element,
                    'Element',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
