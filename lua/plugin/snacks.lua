---@module 'lazy'
---@module 'snacks'

---@type LazySpec
return {
    'folke/snacks.nvim',
    lazy = false,
    version = false,
    priority = 1000,
    keys = {
        {
            '<leader><leader>',
            function()
                require('snacks').picker.commands()
            end,
            mode = { 'n' },
            desc = 'Snacks Picker',
        },
    },
    opts = { ---@type snacks.Config
        picker = {
            prompt = ' ',
            sources = {},
            focus = 'input',
            layout = {
                cycle = true,
                --- Use the default layout or vertical if the window is too narrow
                preset = function()
                    return vim.o.columns >= 120 and 'default' or 'vertical'
                end,
            },
            ---@type snacks.picker.matcher.Config
            matcher = {
                fuzzy = true, -- use fuzzy matching
                smartcase = true, -- use smartcase
                ignorecase = false, -- use ignorecase
                sort_empty = false, -- sort results when the search string is empty
                filename_bonus = true, -- give bonus for matching file names (last part of the path)
                file_pos = true, -- support patterns like `file:line:col` and `file:line`
                -- the bonusses below, possibly require string concatenation and path normalization,
                -- so this can have a performance impact for large lists and increase memory usage
                cwd_bonus = true, -- give bonus for matching files in the cwd
                frecency = false, -- frecency bonus
                history_bonus = false, -- give more weight to chronological order
            },
            sort = {
                -- default sort is by score, text length and index
                fields = { 'score:desc', '#text', 'idx' },
            },
            ui_select = true, -- replace `vim.ui.select` with the snacks picker
            formatters = { ---@type snacks.picker.formatters.Config
                text = {
                    ft = nil, ---@type string? filetype for highlighting
                },
                file = {
                    filename_first = false, -- display filename before the file path
                    truncate = 40, -- truncate the file path to (roughly) this length
                    filename_only = false, -- only show the filename
                    icon_width = 2, -- width of the icon (in characters)
                    git_status_hl = true, -- use the git status highlight group for the filename
                },
                selected = {
                    show_always = true, -- only show the selected column when there are multiple selections
                    unselected = true, -- use the unselected icon for unselected items
                },
                severity = {
                    icons = true, -- show severity icons
                    level = true, -- show severity level
                    ---@type "left"|"right"
                    pos = 'left', -- position of the diagnostics
                },
            },
            ---@type snacks.picker.previewers.Config
            previewers = {
                diff = {
                    builtin = true, -- use Neovim for previewing diffs (true) or use an external tool (false)
                    cmd = { 'delta' }, -- example to show a diff with delta
                },
                git = {
                    builtin = true, -- use Neovim for previewing git output (true) or use git (false)
                    args = {}, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
                },
                file = {
                    max_size = 1024 * 1024, -- 1MB
                    max_line_length = 500, -- max line length
                    ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
                },
                man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
            },
            ---@type snacks.picker.jump.Config
            jump = {
                jumplist = true, -- save the current position in the jumplist
                tagstack = true, -- save the current position in the tagstack
                reuse_win = false, -- reuse an existing window if the buffer is already open
                close = true, -- close the picker when jumping/editing to a location (defaults to true)
                match = false, -- jump to the first match position. (useful for `lines`)
            },
            toggles = {
                follow = 'f',
                hidden = 'h',
                ignored = 'i',
                modified = 'm',
                regex = { icon = 'R', value = false },
            },
            win = {
                input = {
                    keys = {
                        -- to close the picker on ESC instead of going to normal mode,
                        -- add the following keymap to your config
                        -- ["<Esc>"] = { "close", mode = { "n", "i" } },
                        G = 'list_bottom',
                        ['/'] = 'toggle_focus',
                        ['<A-d>'] = { 'inspect', mode = { 'n', 'i' } },
                        ['<A-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
                        ['<A-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
                        ['<A-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
                        ['<A-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
                        ['<A-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
                        ['<A-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
                        ['<C-Down>'] = { 'history_forward', mode = { 'i', 'n' } },
                        ['<C-Up>'] = { 'history_back', mode = { 'i', 'n' } },
                        ['<C-a>'] = { 'select_all', mode = { 'n', 'i' } },
                        ['<C-b>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
                        ['<C-c>'] = { 'cancel', mode = 'i' },
                        ['<C-d>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
                        ['<C-f>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
                        ['<C-g>'] = { 'toggle_live', mode = { 'i', 'n' } },
                        ['<C-j>'] = { 'list_down', mode = { 'i', 'n' } },
                        ['<C-k>'] = { 'list_up', mode = { 'i', 'n' } },
                        ['<C-n>'] = { 'list_down', mode = { 'i', 'n' } },
                        ['<C-p>'] = { 'list_up', mode = { 'i', 'n' } },
                        ['<C-q>'] = { 'qflist', mode = { 'i', 'n' } },
                        ['<C-r>#'] = { 'insert_alt', mode = 'i' },
                        ['<C-r>%'] = { 'insert_filename', mode = 'i' },
                        ['<C-r><C-a>'] = { 'insert_cWORD', mode = 'i' },
                        ['<C-r><C-f>'] = { 'insert_file', mode = 'i' },
                        ['<C-r><C-l>'] = { 'insert_line', mode = 'i' },
                        ['<C-r><C-p>'] = { 'insert_file_full', mode = 'i' },
                        ['<C-r><C-w>'] = { 'insert_cword', mode = 'i' },
                        ['<C-s>'] = { 'edit_split', mode = { 'i', 'n' } },
                        ['<C-t>'] = { 'tab', mode = { 'n', 'i' } },
                        ['<C-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
                        ['<C-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
                        ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
                        ['<C-w>H'] = 'layout_left',
                        ['<C-w>J'] = 'layout_bottom',
                        ['<C-w>K'] = 'layout_top',
                        ['<C-w>L'] = 'layout_right',
                        ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
                        ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
                        ['<Esc>'] = 'cancel',
                        ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
                        ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
                        ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
                        ['?'] = 'toggle_help_input',
                        gg = 'list_top',
                        j = 'list_down',
                        k = 'list_up',
                        q = 'close',
                    },
                    b = {
                        minipairs_disable = true,
                    },
                },
                -- result list window
                list = {
                    keys = {
                        G = 'list_bottom',
                        ['/'] = 'toggle_focus',
                        ['<A-d>'] = 'inspect',
                        ['<A-f>'] = 'toggle_follow',
                        ['<A-h>'] = 'toggle_hidden',
                        ['<A-i>'] = 'toggle_ignored',
                        ['<A-m>'] = 'toggle_maximize',
                        ['<A-p>'] = 'toggle_preview',
                        ['<A-w>'] = 'cycle_win',
                        ['<C-a>'] = 'select_all',
                        ['<C-b>'] = 'preview_scroll_up',
                        ['<C-d>'] = 'list_scroll_down',
                        ['<C-f>'] = 'preview_scroll_down',
                        ['<C-j>'] = 'list_down',
                        ['<C-k>'] = 'list_up',
                        ['<C-n>'] = 'list_down',
                        ['<C-p>'] = 'list_up',
                        ['<C-q>'] = 'qflist',
                        ['<C-s>'] = 'edit_split',
                        ['<C-t>'] = 'tab',
                        ['<C-u>'] = 'list_scroll_up',
                        ['<C-v>'] = 'edit_vsplit',
                        ['<C-w>H'] = 'layout_left',
                        ['<C-w>J'] = 'layout_bottom',
                        ['<C-w>K'] = 'layout_top',
                        ['<C-w>L'] = 'layout_right',
                        ['<CR>'] = 'confirm',
                        ['<Down>'] = 'list_down',
                        ['<Esc>'] = 'cancel',
                        ['<S-Tab>'] = { 'select_and_prev', mode = { 'n', 'x' } },
                        ['<Tab>'] = { 'select_and_next', mode = { 'n', 'x' } },
                        ['<Up>'] = 'list_up',
                        ['?'] = 'toggle_help_list',
                        gg = 'list_top',
                        i = 'focus_input',
                        j = 'list_down',
                        k = 'list_up',
                        q = 'close',
                        zb = 'list_scroll_bottom',
                        zt = 'list_scroll_top',
                        zz = 'list_scroll_center',
                    },
                    wo = {
                        conceallevel = 2,
                        concealcursor = 'nvc',
                    },
                },
                -- preview window
                preview = {
                    keys = {
                        ['<A-w>'] = 'cycle_win',
                        ['<Esc>'] = 'cancel',
                        i = 'focus_input',
                        q = 'close',
                    },
                },
            },
            ---@type snacks.picker.icons
            icons = {
                files = {
                    enabled = true, -- show file icons
                    dir = '󰉋 ',
                    dir_open = '󰝰 ',
                    file = '󰈔 ',
                },
                keymaps = {
                    nowait = '󰓅 ',
                },
                tree = {
                    vertical = '│ ',
                    middle = '├╴',
                    last = '└╴',
                },
                undo = {
                    saved = ' ',
                },
                ui = {
                    live = '󰐰 ',
                    hidden = 'h',
                    ignored = 'i',
                    follow = 'f',
                    selected = '● ',
                    unselected = '○ ',
                    -- selected = " ",
                },
                git = {
                    enabled = true, -- show git icons
                    commit = '󰜘 ', -- used by git log
                    staged = '●', -- staged changes. always overrides the type icons
                    added = '',
                    deleted = '',
                    ignored = ' ',
                    modified = '○',
                    renamed = '',
                    unmerged = ' ',
                    untracked = '?',
                },
                diagnostics = {
                    Error = ' ',
                    Warn = ' ',
                    Hint = ' ',
                    Info = ' ',
                },
                lsp = {
                    unavailable = '',
                    enabled = ' ',
                    disabled = ' ',
                    attached = '󰖩 ',
                },
                kinds = {
                    Array = ' ',
                    Boolean = '󰨙 ',
                    Class = ' ',
                    Color = ' ',
                    Control = ' ',
                    Collapsed = ' ',
                    Constant = '󰏿 ',
                    Constructor = ' ',
                    Copilot = ' ',
                    Enum = ' ',
                    EnumMember = ' ',
                    Event = ' ',
                    Field = ' ',
                    File = ' ',
                    Folder = ' ',
                    Function = '󰊕 ',
                    Interface = ' ',
                    Key = ' ',
                    Keyword = ' ',
                    Method = '󰊕 ',
                    Module = ' ',
                    Namespace = '󰦮 ',
                    Null = ' ',
                    Number = '󰎠 ',
                    Object = ' ',
                    Operator = ' ',
                    Package = ' ',
                    Property = ' ',
                    Reference = ' ',
                    Snippet = '󱄽 ',
                    String = ' ',
                    Struct = '󰆼 ',
                    Text = ' ',
                    TypeParameter = ' ',
                    Unit = ' ',
                    Unknown = ' ',
                    Value = ' ',
                    Variable = '󰀫 ',
                },
            },
            ---@type snacks.picker.db.Config
            db = {
                -- path to the sqlite3 library
                -- If not set, it will try to load the library by name.
                -- On Windows it will download the library from the internet.
                sqlite3_path = nil, ---@type string?
            },
            ---@type snacks.picker.debug
            debug = {
                scores = false, -- show scores in the list
                leaks = false, -- show when pickers don't get garbage collected
                explorer = false, -- show explorer debug info
                files = false, -- show file debug info
                grep = false, -- show file debug info
                proc = false, -- show proc debug info
                extmarks = false, -- show extmarks errors
            },
        },
        dim = { enabled = true },
        input = { enabled = true },
        layout = { enabled = true },
        notify = { enabled = true },
    },
}
