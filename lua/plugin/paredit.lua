local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('nvim-paredit') then
    User.deregister_plugin('plugin.paredit')
    return
end

local Paredit = require('nvim-paredit')

Paredit.setup({
    -- Should plugin use default keybindings? (default = true)
    use_default_keys = false,
    -- Sometimes user wants to restrict plugin to certain filetypes only or add support
    -- for new filetypes.
    --
    -- Defaults to all supported filetypes.
    filetypes = { 'clojure', 'fennel', 'scheme', 'lisp', 'janet' },

    -- This is some language specific configuration. Right now this is just used for
    -- setting character lists that are considered whitespace.
    languages = {
        clojure = {
            whitespace_chars = { ' ', ',' },
        },
        fennel = {
            whitespace_chars = { ' ', ',' },
        },
    },

    -- This controls where the cursor is placed when performing slurp/barf operations
    --
    -- - "remain" - It will never change the cursor position, keeping it in the same place
    -- - "follow" - It will always place the cursor on the form edge that was moved
    -- - "auto"   - A combination of remain and follow, it will try keep the cursor in the original position
    --              unless doing so would result in the cursor no longer being within the original form. In
    --              this case it will place the cursor on the moved edge
    cursor_behaviour = 'auto', -- remain, follow, auto

    dragging = {
        -- If set to `true` paredit will attempt to infer if an element being
        -- dragged is part of a 'paired' form like as a map. If so then the element
        -- will be dragged along with it's pair.
        auto_drag_pairs = true,
    },

    indent = {
        -- This controls how nvim-paredit handles indentation when performing operations which
        -- should change the indentation of the form (such as when slurping or barfing).
        --
        -- When set to true then it will attempt to fix the indentation of nodes operated on.
        enabled = true,
        -- A function that will be called after a slurp/barf if you want to provide a custom indentation
        -- implementation.
        indentor = require('nvim-Paredit.indentation.native').indentor,
    },

    -- list of default keybindings
    keys = {
        ['<localleader>@'] = { Paredit.unwrap.unwrap_form_under_cursor, 'Splice sexp' },
        ['<localleader>o'] = false,
        ['<localleader>O'] = false,
        ['<localleader>Po'] = { Paredit.api.raise_form, 'Raise form' },
        ['<localleader>PO'] = { Paredit.api.raise_element, 'Raise element' },

        ['>)'] = { Paredit.api.slurp_forwards, 'Slurp forwards' },
        ['>('] = { Paredit.api.barf_backwards, 'Barf backwards' },

        ['<)'] = { Paredit.api.barf_forwards, 'Barf forwards' },
        ['<('] = { Paredit.api.slurp_backwards, 'Slurp backwards' },

        ['>e'] = { Paredit.api.drag_element_forwards, 'Drag element right' },
        ['<e'] = { Paredit.api.drag_element_backwards, 'Drag element left' },

        ['>p'] = { Paredit.api.drag_pair_forwards, 'Drag element pairs right' },
        ['<p'] = { Paredit.api.drag_pair_backwards, 'Drag element pairs left' },

        ['>f'] = { Paredit.api.drag_form_forwards, 'Drag form right' },
        ['<f'] = { Paredit.api.drag_form_backwards, 'Drag form left' },

        ['E'] = {
            Paredit.api.move_to_next_element_tail,
            'Jump to next element tail',
            -- by default all keybindings are dot repeatable
            repeatable = false,
            mode = { 'n', 'x', 'o', 'v' },
        },
        ['W'] = {
            Paredit.api.move_to_next_element_head,
            'Jump to next element head',
            repeatable = false,
            mode = { 'n', 'x', 'o', 'v' },
        },

        ['B'] = {
            Paredit.api.move_to_prev_element_head,
            'Jump to previous element head',
            repeatable = false,
            mode = { 'n', 'x', 'o', 'v' },
        },
        ['gE'] = {
            Paredit.api.move_to_prev_element_tail,
            'Jump to previous element tail',
            repeatable = false,
            mode = { 'n', 'x', 'o', 'v' },
        },

        ['('] = {
            Paredit.api.move_to_parent_form_start,
            "Jump to parent form's head",
            repeatable = false,
            mode = { 'n', 'x', 'v' },
        },
        [')'] = {
            Paredit.api.move_to_parent_form_end,
            "Jump to parent form's tail",
            repeatable = false,
            mode = { 'n', 'x', 'v' },
        },

        -- These are text object selection keybindings which can used with standard `d, y, c`, `v`
        ['af'] = {
            Paredit.api.select_around_form,
            'Around form',
            repeatable = false,
            mode = { 'o', 'v' },
        },
        ['if'] = {
            Paredit.api.select_in_form,
            'In form',
            repeatable = false,
            mode = { 'o', 'v' },
        },
        ['aF'] = {
            Paredit.api.select_around_top_level_form,
            'Around top level form',
            repeatable = false,
            mode = { 'o', 'v' },
        },
        ['iF'] = {
            Paredit.api.select_in_top_level_form,
            'In top level form',
            repeatable = false,
            mode = { 'o', 'v' },
        },
        ['ae'] = {
            Paredit.api.select_element,
            'Around element',
            repeatable = false,
            mode = { 'o', 'v' },
        },
        ['ie'] = {
            Paredit.api.select_element,
            'Element',
            repeatable = false,
            mode = { 'o', 'v' },
        },
    },
})

User.register_plugin('plugin.paredit')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
