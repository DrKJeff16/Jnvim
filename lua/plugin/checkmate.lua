---@module 'lazy'

---@type LazySpec
return {
    'bngarren/checkmate.nvim',
    ft = 'markdown',
    version = false,
    ---@type checkmate.Config
    opts = {
        enabled = true,
        notify = true,
        -- Default file matching:
        --  - Any `todo` or `TODO` file, including with `.md` extension
        --  - Any `.todo` extension (can be ".todo" or ".todo.md")
        -- To activate Checkmate, the filename must match AND the filetype must be "markdown"
        files = {
            'todo',
            'TODO',
            'todo.md',
            'TODO.md',
            '*.todo',
            '*.todo.md',
        },
        log = {
            level = 'warn',
            use_file = true,
        },
        -- Default keymappings
        keys = {
            ['<leader><C-c>t'] = {
                rhs = '<cmd>Checkmate toggle<CR>',
                desc = 'Toggle todo item',
                modes = { 'n', 'v' },
            },
            ['<leader><C-c>c'] = {
                rhs = '<cmd>Checkmate check<CR>',
                desc = 'Set todo item as checked (done)',
                modes = { 'n', 'v' },
            },
            ['<leader><C-c>u'] = {
                rhs = '<cmd>Checkmate uncheck<CR>',
                desc = 'Set todo item as unchecked (not done)',
                modes = { 'n', 'v' },
            },
            ['<leader><C-c>='] = {
                rhs = '<cmd>Checkmate cycle_next<CR>',
                desc = 'Cycle todo item(s) to the next state',
                modes = { 'n', 'v' },
            },
            ['<leader><C-c>-'] = {
                rhs = '<cmd>Checkmate cycle_previous<CR>',
                desc = 'Cycle todo item(s) to the previous state',
                modes = { 'n', 'v' },
            },
            ['<leader><C-c>n'] = {
                rhs = '<cmd>Checkmate create<CR>',
                desc = 'Create todo item',
                modes = { 'n', 'v' },
            },
            ['<leader><C-c>R'] = {
                rhs = '<cmd>Checkmate remove_all_metadata<CR>',
                desc = 'Remove all metadata from a todo item',
                modes = { 'n', 'v' },
            },
            ['<leader><C-c>a'] = {
                rhs = '<cmd>Checkmate archive<CR>',
                desc = 'Archive checked/completed todo items (move to bottom section)',
                modes = { 'n' },
            },
            ['<leader><C-c>v'] = {
                rhs = '<cmd>Checkmate metadata select_value<CR>',
                desc = 'Update the value of a metadata tag under the cursor',
                modes = { 'n' },
            },
            ['<leader><C-c>]'] = {
                rhs = '<cmd>Checkmate metadata jump_next<CR>',
                desc = 'Move cursor to next metadata tag',
                modes = { 'n' },
            },
            ['<leader><C-c>['] = {
                rhs = '<cmd>Checkmate metadata jump_previous<CR>',
                desc = 'Move cursor to previous metadata tag',
                modes = { 'n' },
            },
        },
        default_list_marker = '-',
        todo_states = {
            -- we don't need to set the `markdown` field for `unchecked` and `checked` as these can't be overriden
            ---@diagnostic disable-next-line: missing-fields
            unchecked = {
                marker = '□',
                order = 1,
            },
            ---@diagnostic disable-next-line: missing-fields
            checked = {
                marker = '✔',
                order = 2,
            },
        },
        style = {}, -- override defaults
        enter_insert_after_new = true, -- Should enter INSERT mode after `:Checkmate create` (new todo)
        smart_toggle = {
            enabled = true,
            include_cycle = false,
            check_down = 'direct_children',
            uncheck_down = 'none',
            check_up = 'direct_children',
            uncheck_up = 'direct_children',
        },
        show_todo_count = true,
        todo_count_position = 'eol',
        todo_count_recursive = true,
        use_metadata_keymaps = true,
        metadata = {
            -- Example: A @priority tag that has dynamic color based on the priority value
            priority = {
                style = function(context)
                    local value = context.value:lower()
                    if value == 'high' then
                        return { fg = '#ff5555', bold = true }
                    elseif value == 'medium' then
                        return { fg = '#ffb86c' }
                    elseif value == 'low' then
                        return { fg = '#8be9fd' }
                    else -- fallback
                        return { fg = '#8be9fd' }
                    end
                end,
                get_value = function()
                    return 'medium' -- Default priority
                end,
                choices = function()
                    return { 'low', 'medium', 'high' }
                end,
                key = '<leader><C-c>p',
                sort_order = 10,
                jump_to_on_insert = 'value',
                select_on_insert = true,
            },
            -- Example: A @started tag that uses a default date/time string when added
            started = {
                aliases = { 'init' },
                style = { fg = '#9fd6d5' },
                get_value = function()
                    return tostring(os.date('%m/%d/%y %H:%M'))
                end,
                key = '<leader><C-c>s',
                sort_order = 20,
            },
            -- Example: A @done tag that also sets the todo item state when it is added and removed
            done = {
                aliases = { 'completed', 'finished' },
                style = { fg = '#96de7a' },
                get_value = function()
                    return tostring(os.date('%m/%d/%y %H:%M'))
                end,
                key = '<leader><C-c>d',
                on_add = function(todo_item)
                    require('checkmate').set_todo_item(todo_item, 'checked')
                end,
                on_remove = function(todo_item)
                    require('checkmate').set_todo_item(todo_item, 'unchecked')
                end,
                sort_order = 30,
            },
        },
        archive = {
            heading = {
                title = 'Archive',
                level = 2, -- e.g. ##
            },
            parent_spacing = 0, -- no extra lines between archived todos
            newest_first = true,
        },
        linter = {
            enabled = true,
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
