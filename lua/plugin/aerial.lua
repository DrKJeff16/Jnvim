-- ctx: a record containing the following fields:
--   * backend_name: treesitter, lsp, man...
--   * lang: info about the language
--   * symbols?: specific to the lsp backend
--   * symbol?: specific to the lsp backend
--   * syntax_tree?: specific to the treesitter backend
--   * match?: specific to the treesitter backend, TS query match
---@class aerial.Ctx
---@field backend_name 'treesitter'|'lsp'|'man'|'asciidoc'|'markdown'
---@field lang string info about the language
---@field symbols? string[] specific to the lsp backend
---@field symbol? string specific to the lsp backend
---@field syntax_tree? table specific to the treesitter backend
---@field match? table specific to the treesitter backend, TS query match

local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local desc = User.maps.desc

if not exists('aerial') then
    User.deregister_plugin('plugin.aerial')
    return
end

local Aerial = require('aerial')

Aerial.setup({
    -- Priority list of preferred backends for aerial.
    -- This can be a filetype map (see :help aerial-filetype-map)
    backends = { 'lsp', 'treesitter', 'markdown', 'man', 'asciidoc' },

    layout = {
        -- These control the width of the aerial window.
        -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a list of mixed types.
        -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
        max_width = { 40, 0.4 },
        width = nil,
        min_width = 20,

        -- key-value pairs of window-local options for aerial window (e.g. winhl)
        win_opts = {},

        -- Determines the default direction to open the aerial window. The 'prefer'
        -- options will open the window in the other direction *if* there is a
        -- different buffer in the way of the preferred direction
        -- Enum: prefer_right, prefer_left, right, left, float
        --
        ---@type 'prefer_right'|'prefer_left'|'right'|'left'|'float'
        default_direction = 'prefer_right',

        -- Determines where the aerial window will be opened
        --   edge   - open aerial at the far right/left of the editor
        --   window - open aerial to the right/left of the current window
        --
        ---@type 'edge'|'window'
        placement = 'window',

        -- When the symbols change, resize the aerial window (within min/max constraints) to fit
        resize_to_content = true,

        -- Preserve window size equality with (:help CTRL-W_=)
        --
        ---@type boolean
        preserve_equality = vim.opt.equalalways:get(),
    },

    -- Determines how the aerial window decides which buffer to display symbols for
    --   window - aerial window will display symbols for the buffer in the window from which it was opened
    --   global - aerial window will display symbols for the current window
    ---@type 'window'|'global'
    attach_mode = 'global',

    -- List of enum values that configure when to auto-close the aerial window
    --   unfocus       - close aerial when you leave the original source window
    --   switch_buffer - close aerial when you change buffers in the source window
    --   unsupported   - close aerial when attaching to a buffer that has no symbol source
    close_automatic_events = {},

    -- Keymaps in aerial window. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
    -- Additionally, if it is a string that matches "actions.<name>",
    -- it will use the mapping at require("aerial.actions").<name>
    -- Set to `false` to remove a keymap
    keymaps = {
        ['?'] = 'actions.show_help',

        ['<CR>'] = 'actions.jump',

        ['<C-v>'] = 'actions.jump_vsplit',
        ['<C-x>'] = 'actions.jump_split',

        ['p'] = 'actions.scroll',

        ['<C-j>'] = 'actions.down_and_scroll',
        ['<C-k>'] = 'actions.up_and_scroll',

        ['{'] = 'actions.prev',
        ['}'] = 'actions.next',
        ['[['] = 'actions.prev_up',
        [']]'] = 'actions.next_up',

        ['q'] = 'actions.close',

        ['o'] = 'actions.tree_toggle',
        ['O'] = 'actions.tree_toggle_recursive',

        ['l'] = 'actions.tree_open',
        ['L'] = 'actions.tree_open_recursive',

        ['h'] = 'actions.tree_close',
        ['H'] = 'actions.tree_close_recursive',

        -- ['zr'] = 'actions.tree_increase_fold_level',
        -- ['zR'] = 'actions.tree_open_all',
        -- ['zm'] = 'actions.tree_decrease_fold_level',
        -- ['zM'] = 'actions.tree_close_all',
        -- ['zx'] = 'actions.tree_sync_folds',
        -- ['zX'] = 'actions.tree_sync_folds',
    },

    -- When true, don't load aerial until a command or function is called
    -- Defaults to true, unless `on_attach` is provided, then it defaults to false
    lazy_load = false,

    -- Disable aerial on files with this many lines
    disable_max_lines = 10000,

    -- Disable aerial on files this size or larger (in bytes)
    disable_max_size = 2000000, -- Default 2MB

    -- A list of all symbols to display. Set to false to display all symbols.
    -- This can be a filetype map (see :help aerial-filetype-map)
    -- To see all available values, see :help SymbolKind
    filter_kind = {
        'Class',
        'Constructor',
        'Enum',
        'Function',
        'Interface',
        'Module',
        'Method',
        'Struct',
    },

    -- Determines line highlighting mode when multiple splits are visible.
    -- split_width   Each open window will have its cursor location marked in the
    --               aerial buffer. Each line will only be partially highlighted
    --               to indicate which window is at that location.
    -- full_width    Each open window will have its cursor location marked as a
    --               full-width highlight in the aerial buffer.
    -- last          Only the most-recently focused window will have its location
    --               marked in the aerial buffer.
    -- none          Do not show the cursor locations in the aerial window.
    --
    ---@type 'split_width'|'full_width'|'last'|'none'
    highlight_mode = 'split_width',

    -- Highlight the closest symbol if the cursor is not exactly on one.
    highlight_closest = true,

    -- Highlight the symbol in the source buffer when cursor is in the aerial win
    highlight_on_hover = true,

    -- When jumping to a symbol, highlight the line for this many ms.
    -- Set to false to disable
    highlight_on_jump = 300,

    -- Jump to symbol in source window when the cursor moves
    autojump = true,

    -- Define symbol icons. You can also specify "<Symbol>Collapsed" to change the
    -- icon when the tree is collapsed at that symbol, or "Collapsed" to specify a
    -- default collapsed icon. The default icon set is determined by the
    -- "nerd_font" option below.
    -- If you have lspkind-nvim installed, it will be the default icon set.
    -- This can be a filetype map (see :help aerial-filetype-map)
    icons = {},

    -- Control which windows and buffers aerial should ignore.
    -- Aerial will not open when these are focused, and existing aerial windows will not be updated
    ignore = {
        -- Ignore unlisted buffers. See :help buflisted
        unlisted_buffers = false,

        -- Ignore diff windows (setting to false will allow aerial in diff windows)
        diff_windows = true,

        -- List of filetypes to ignore.
        filetypes = {},

        -- Ignored buftypes.
        -- Can be one of the following:
        -- false or nil - No buftypes are ignored.
        -- "special"    - All buffers other than normal, help and man page buffers are ignored.
        -- table        - A list of buftypes to ignore. See :help buftype for the
        --                possible values.
        -- function     - A function that returns true if the buffer should be
        --                ignored or false if it should not be ignored.
        --                Takes two arguments, `bufnr` and `buftype`.
        --
        ---@type nil|false|'special'|(''|'acwrite'|'help'|'nofile'|'nowrite'|'prompt'|'quickfix'|'locations'|'terminal')[]|fun(bufnr: integer, buftype: string): boolean
        buftypes = 'special',

        -- Ignored wintypes.
        -- Can be one of the following:
        -- false or nil - No wintypes are ignored.
        -- "special"    - All windows other than normal windows are ignored.
        -- table        - A list of wintypes to ignore. See :help win_gettype() for the
        --                possible values.
        -- function     - A function that returns true if the window should be
        --                ignored or false if it should not be ignored.
        --                Takes two arguments, `winid` and `wintype`.
        --
        ---@type nil|false|'special'|('autocmd'|'command'|''|'loclist'|'popup'|'preview'|'quickfix'|'unknown')[]|fun(bufnr: integer, buftype: string): boolean
        wintypes = 'special',
    },

    -- Use symbol tree for folding. Set to true or false to enable/disable
    -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
    -- This can be a filetype map (see :help aerial-filetype-map)
    --
    ---@type boolean|'auto'
    manage_folds = false,

    -- When you fold code with za, zo, or zc, update the aerial tree as well.
    -- Only works when manage_folds = true
    link_folds_to_tree = false,

    -- Fold code when you open/collapse symbols in the tree.
    -- Only works when manage_folds = true
    link_tree_to_folds = true,

    -- Set default symbol icons to use patched font icons (see https://www.nerdfonts.com/)
    -- "auto" will set it to true if nvim-web-devicons or lspkind-nvim is installed.
    nerd_font = 'auto',

    -- Call this function when aerial first sets symbols on a buffer.
    --
    ---@type fun(bufnr: integer)
    -- on_first_symbols = function(bufnr) end,

    -- Automatically open aerial when entering supported buffers.
    -- This can be a function (see :help aerial-open-automatic)
    open_automatic = false,

    -- Run this command after jumping to a symbol (false will disable)
    post_jump_cmd = 'normal! zz',

    -- Invoked after each symbol is parsed, can be used to modify the parsed item,
    -- or to filter it by returning false.
    --
    -- bufnr: a neovim buffer number
    -- item: of type aerial.Symbol
    -- ctx: a record containing the following fields:
    --   * backend_name: treesitter, lsp, man...
    --   * lang: info about the language
    --   * symbols?: specific to the lsp backend
    --   * symbol?: specific to the lsp backend
    --   * syntax_tree?: specific to the treesitter backend
    --   * match?: specific to the treesitter backend, TS query match
    --
    ---@param bufnr integer
    ---@param item aerial.Symbol
    ---@param ctx aerial.Ctx
    post_parse_symbol = function(bufnr, item, ctx)
        return true
    end,

    -- Invoked after all symbols have been parsed and post-processed,
    -- allows to modify the symbol structure before final display
    --
    -- bufnr: a neovim buffer number
    -- items: a collection of aerial.Symbol items, organized in a tree,
    --        with 'parent' and 'children' fields
    -- ctx: a record containing the following fields:
    --   * backend_name: treesitter, lsp, man...
    --   * lang: info about the language
    --   * symbols?: specific to the lsp backend
    --   * syntax_tree?: specific to the treesitter backend
    ---@param bufnr integer
    ---@param items aerial.Symbol
    ---@param ctx table
    post_add_all_symbols = function(bufnr, items, ctx)
        return items
    end,

    -- When true, aerial will automatically close after jumping to a symbol
    close_on_select = false,

    -- The autocmds that trigger symbols update (not used for LSP backend)
    update_events = 'TextChanged,InsertLeave',

    -- Show box drawing characters for the tree hierarchy
    show_guides = true,

    -- Customize the characters used when show_guides = true
    guides = {
        -- When the child item has a sibling below it
        mid_item = '├─',
        -- When the child item is the last in the list
        last_item = '└─',
        -- When there are nested child guides to the right
        nested_top = '│ ',
        -- Raw indentation
        whitespace = '  ',
    },

    -- Set this function to override the highlight groups for certain symbols
    get_highlight = function(symbol, is_icon, is_collapsed)
        -- return "MyHighlight" .. symbol.kind
    end,

    -- Options for opening aerial in a floating win
    float = {
        -- Controls border appearance. Passed to nvim_open_win
        border = 'rounded',

        -- Determines location of floating window
        --   cursor - Opens float on top of the cursor
        --   editor - Opens float centered in the editor
        --   win    - Opens float centered in the window
        relative = 'cursor',

        -- These control the height of the floating window.
        -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a list of mixed types.
        -- min_height = {8, 0.1} means "the greater of 8 rows or 10% of total"
        max_height = 0.9,
        height = nil,
        min_height = { 8, 0.1 },

        override = function(conf, source_winid)
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
        end,
    },

    -- Options for the floating nav windows
    nav = {
        border = 'rounded',
        max_height = 0.9,
        min_height = { 10, 0.1 },
        max_width = 0.5,
        min_width = { 0.2, 20 },
        win_opts = {
            cursorline = true,
            winblend = 10,
        },
        -- Jump to symbol in source window when the cursor moves
        autojump = false,
        -- Show a preview of the code in the right column, when there are no child symbols
        preview = false,
        -- Keymaps in the nav window
        keymaps = {
            ['<CR>'] = 'actions.jump',

            ['<C-v>'] = 'actions.jump_vsplit',
            ['<C-x>'] = 'actions.jump_split',

            ['h'] = 'actions.left',
            ['l'] = 'actions.right',

            ['<C-c>'] = 'actions.close',
        },
    },

    lsp = {
        -- If true, fetch document symbols when LSP diagnostics update.
        diagnostics_trigger_update = false,

        -- Set to false to not update the symbols when there are LSP errors
        update_when_errors = true,

        -- How long to wait (in ms) after a buffer change before updating
        -- Only used when diagnostics_trigger_update = false
        update_delay = 1000,

        -- Map of LSP client name to priority. Default value is 10.
        -- Clients with higher (larger) priority will be used before those with lower priority.
        -- Set to -1 to never use the client.
        --
        ---@type table<string, integer>
        priority = {
            -- pyright = 10,
        },
    },

    treesitter = {
        -- How long to wait (in ms) after a buffer change before updating
        update_delay = 300,
    },

    markdown = {
        -- How long to wait (in ms) after a buffer change before updating
        update_delay = 300,
    },

    asciidoc = {
        -- How long to wait (in ms) after a buffer change before updating
        update_delay = 300,
    },

    man = {
        -- How long to wait (in ms) after a buffer change before updating
        update_delay = 300,
    },

    ---@param bufnr integer
    on_attach = function(bufnr)
        ---@type AllModeMaps
        local Keys = {
            n = {
                ['{'] = {
                    vim.cmd.AerialPrev,
                    desc('Aerial Previous', true, bufnr),
                },
                ['}'] = {
                    vim.cmd.AerialNext,
                    desc('Aerial Next', true, bufnr),
                },
            },
        }

        Keymaps(Keys, bufnr)
    end,
})

if exists('snacks') then
    Aerial.snacks_picker({
        layout = {
            preset = 'dropdown',
            preview = false,
        },
    })
end

---@type AllMaps
local Keys = {
    ['<leader>la'] = { group = '+Aerial' },

    ['<leader>lat'] = {
        vim.cmd.AerialToggle,
        desc('Toggle Aerial'),
    },
    ['<leader>lao'] = {
        vim.cmd.AerialOpen,
        desc('Open Aerial'),
    },
    ['<leader>lac'] = {
        vim.cmd.AerialClose,
        desc('Close Aerial'),
    },
    ['<leader>lai'] = {
        vim.cmd.AerialInfo,
        desc('Aerial Info'),
    },
}

Keymaps({ n = Keys })

User.register_plugin('plugin.aerial')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
