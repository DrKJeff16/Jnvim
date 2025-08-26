---@alias AnyFunc fun(...: any)
---@alias TreeApi table<string, string|AnyFunc|table>
---@alias OptSetterFun fun(desc: string, bufn: integer?): KeyMapOpts

---@class BufData
---@field file string
---@field buf integer

---@class TreeToggleOpts
---@field focus? boolean Defaults to `true`
---@field find_file? boolean Defaults to `false`
---@field path? string|nil Defaults to `nil`
---@field current_window? boolean Defaults to `false`
---@field update_root? boolean Defaults to `false`

---@class TreeOpenOpts
---@field find_file? boolean Defaults to `false`
---@field path? string|nil Defaults to `nil`
---@field current_window? boolean Defaults to `false`
---@field update_root? boolean Defaults to `false`

---@class TreeNodeGSDir
---@field direct? string[]
---@field indirect? string[]

---@class TreeNodeGitStatus
---@field file? string
---@field dir TreeNodeGSDir

---@class TreeNode
---@field git_status TreeNodeGitStatus
---@field absolute_path string
---@field file string
---@field nodes any

---@class TreeGitConds
---@field add string[]
---@field restore string[]

local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty
local type_not_empty = Check.value.type_not_empty
local hi = User.highlight.hl_from_dict
local au = User.util.au.au_from_dict
local desc = User.maps.desc

if not exists('nvim-tree') then
    User.deregister_plugin('plugin.nvim_tree')
    return
end

--- NOTE: Use floating Tree? You decide
local USE_FLOAT = false

local D_ERR = vim.diagnostic.severity.ERROR
local D_WARN = vim.diagnostic.severity.WARN
local fn = vim.fn

local sched = vim.schedule
local sched_wp = vim.schedule_wrap
local in_tbl = vim.tbl_contains
local filter = vim.tbl_filter
local tbl_map = vim.tbl_map

local augroup = vim.api.nvim_create_augroup
local get_tabpage = vim.api.nvim_win_get_tabpage
local get_bufn = vim.api.nvim_win_get_buf
local win_list = vim.api.nvim_tabpage_list_wins
local close_win = vim.api.nvim_win_close
local list_wins = vim.api.nvim_list_wins

local floor = math.floor

local Tree = require('nvim-tree')
local Api = require('nvim-tree.api')

local FsApi = Api.fs
local TMarks = Api.marks
local Tapi = Api.tree
local Tnode = Api.node

---@class Tree.CfgAPI.Mappings
---@field default_on_attach fun(bufnr: integer)

---@class Tree.CfgAPI
---@field mappings Tree.CfgAPI.Mappings

---@type Tree.CfgAPI
local CfgApi = require('nvim-tree.api').config

---@type AnyFunc
local open = Tapi.open
---@type AnyFunc
local close = Tapi.close
---@type AnyFunc
local toggle = Tapi.toggle
---@type AnyFunc
local toggle_help = Tapi.toggle_help
---@type AnyFunc
local focus = Tapi.focus
---@type AnyFunc
local reload = Tapi.reload
---@type AnyFunc
local get_node = Tapi.get_node_under_cursor
---@type AnyFunc
local collapse_all = Tapi.collapse_all

local function open_tab_silent(node)
    Tnode.open.tab(node)
    vim.cmd.tabprevious()
end

local function change_root_to_global_cwd()
    local global_cwd = vim.fn.getcwd(-1, -1)
    Tapi.change_root(global_cwd)
end

---@param keys AllMaps
---@param bufnr? integer
local function map_keys(keys, bufnr)
    if not type_not_empty('table', keys) then
        return
    end

    bufnr = is_int(bufnr) and bufnr or nil

    Keymaps({ n = keys }, bufnr)
end

---@type AllMaps
local my_maps = {
    ['<leader>ft'] = { group = '+NvimTree' },

    ['<leader>fto'] = {
        open,
        desc('Open NvimTree'),
    },
    ['<leader>ftt'] = {
        function()
            toggle({ find_file = true, update_root = true, focus = true })
        end,
        desc('Toggle NvimTree'),
    },
    ['<leader>ftd'] = {
        close,
        desc('Close NvimTree'),
    },

    ['<leader>ftf'] = {
        focus,
        desc('Focus NvimTree'),
    },
}

Keymaps({ n = my_maps })

---@param nwin? integer
local function tab_win_close(nwin)
    nwin = is_int(nwin) and nwin or vim.api.nvim_get_current_tabpage()

    local ntab = get_tabpage(nwin)
    local nbuf = get_bufn(nwin)
    local buf_info = fn.getbufinfo(nbuf)[1]

    local tab_wins = filter(function(w)
        return w - nwin
    end, win_list(ntab))
    local tab_bufs = tbl_map(get_bufn, tab_wins)

    if buf_info.name:match('.*NvimTree_%d*$') and not empty(tab_bufs) then
        close()
    elseif #tab_bufs == 1 then
        local lbuf_info = fn.getbufinfo(tab_bufs[1])[1]

        if lbuf_info.name:match('.*NvimTree_%d*$') then
            sched(function()
                if #list_wins() == 1 then
                    vim.cmd.quit()
                else
                    close_win(tab_wins[1], true)
                end
            end)
        end
    end
end

---@param data vim.api.keyset.create_autocmd.callback_args
local function tree_open(data)
    if not type_not_empty('string', data.file) then
        return
    end

    local nbuf = data.buf
    local name = data.file

    local buf = vim.bo[nbuf]

    local real = fn.filereadable(name) == 1
    local no_name = (name == '' and buf.buftype == '')
    local dir = fn.isdirectory(name) == 1

    if not (real or no_name) then
        return
    end

    local ft = buf.ft
    local noignore = {}

    if ft == '' or not (type_not_empty('table', noignore) and in_tbl(noignore, ft)) then
        return
    end

    ---@type TreeToggleOpts
    local toggle_opts = { focus = false, find_file = true, update_root = true }

    if dir then
        vim.cmd('cd ' .. name)
        open(toggle_opts)
        vim.schedule(change_root_to_global_cwd)
    else
        toggle(toggle_opts)
    end
end

local function edit_or_open()
    ---@type AnyFunc
    local edit = Tnode.open.edit

    ---@type TreeNode
    local node = Tapi.get_node_under_cursor()
    local nodes = node.nodes or nil

    edit()

    if nodes ~= nil then
        close()
    end
end

local function vsplit_preview()
    ---@type TreeNode
    local node = get_node()
    local nodes = node.nodes or nil

    ---@type AnyFunc
    local edit = Tnode.open.edit
    ---@type AnyFunc
    local vert = Tnode.open.vertical

    if nodes ~= nil then
        edit()
    else
        vert()
    end

    focus()
end

local function git_add()
    ---@type TreeNode
    local node = get_node()

    local ngs = node.git_status
    local ngsf = ngs.file
    local abs = node.absolute_path
    local gs = ngsf or ''

    if empty(gs) then
        if type_not_empty('table', ngs.dir.direct) then
            gs = ngs.dir.direct[1]
        elseif type_not_empty('table', ngs.dir.indirect) then
            gs = ngs.dir.indirect[1]
        end
    end

    ---@type TreeGitConds
    local conds = {
        add = { '??', 'MM', 'AM', ' M' },
        restore = { 'M ', 'A ' },
    }

    if in_tbl(conds.add, gs) then
        fn.system('git add ' .. abs)
    elseif in_tbl(conds.restore, gs) then
        fn.system('git restore --staged ' .. abs)
    end

    reload()
end

local function swap_then_open_tab()
    ---@type AnyFunc
    local tab = Tnode.open.tab

    ---@type TreeNode
    local node = get_node()

    if is_tbl(node) and not empty(node) then
        vim.cmd.wincmd('l')
        tab(node)
    end
end

---@param bufnr integer
local on_attach = function(bufnr)
    CfgApi.mappings.default_on_attach(bufnr)

    -- custom mappings
    local function change_root_to_node(node)
        if node == nil then
            node = Tapi.get_node_under_cursor()
        end

        if node ~= nil and node.type == 'directory' then
            vim.api.nvim_set_current_dir(node.absolute_path)
        end

        Tapi.change_root_to_node(node)
    end

    local function change_root_to_parent(node)
        local abs_path
        if node == nil then
            abs_path = get_node().absolute_path
        else
            abs_path = node.absolute_path
        end

        local parent_path = vim.fs.dirname(abs_path)
        vim.api.nvim_set_current_dir(parent_path)
        vim.schedule(function()
            Tapi.change_root(parent_path)
        end)
    end

    ---@type AllMaps
    local Keys = {
        -- BEGIN_DEFAULT_ON_ATTACH
        ['-'] = { change_root_to_parent, desc('Up', true, bufnr) },
        ['.'] = { Tnode.run.cmd, desc('Run Command', true, bufnr) },
        ['<'] = { Tnode.navigate.sibling.prev, desc('Previous Sibling', true, bufnr) },
        ['<BS>'] = { Tnode.navigate.parent_close, desc('Close Directory', true, bufnr) },
        ['<C-U>'] = { change_root_to_parent, desc('Set Root To Upper Dir', true, bufnr) },
        ['<C-]>'] = { change_root_to_node, desc('CD', true, bufnr) },
        ['<C-c>'] = { change_root_to_global_cwd, desc('Change Root To Global CWD', true, bufnr) },
        ['<C-e>'] = { Tnode.open.replace_tree_buffer, desc('Open: In Place', true, bufnr) },
        ['<C-f>'] = { edit_or_open, desc('Edit Or Open', true, bufnr) },
        ['<C-k>'] = { Tnode.show_info_popup, desc('Info', true, bufnr) },
        ['<C-r>'] = { FsApi.rename_sub, desc('Rename: Omit Filename', true, bufnr) },
        ['<C-t>'] = { change_root_to_parent, desc('Change Root To Parent', true, bufnr) },
        ['<C-v>'] = { Tnode.open.vertical, desc('Open: Vertical Split', true, bufnr) },
        ['<C-x>'] = { Tnode.open.horizontal, desc('Open: Horizontal Split', true, bufnr) },
        ['<CR>'] = { Tnode.open.edit, desc('Open', true, bufnr) },
        ['<Tab>'] = { Tnode.open.preview, desc('Open Preview', true, bufnr) },
        ['>'] = { Tnode.navigate.sibling.next, desc('Next Sibling', true, bufnr) },
        ['?'] = { toggle_help, desc('Help', true, bufnr) },
        ['B'] = { Tapi.toggle_no_buffer_filter, desc('Toggle No Buffer', true, bufnr) },
        ['C'] = { Tapi.toggle_git_clean_filter, desc('Toggle Git Clean', true, bufnr) },
        ['D'] = { FsApi.trash, desc('Trash', true, bufnr) },
        ['E'] = { Tapi.expand_all, desc('Expand All', true, bufnr) },
        ['F'] = { Api.live_filter.clear, desc('Clean Filter', true, bufnr) },
        ['H'] = { Tapi.toggle_hidden_filter, desc('Toggle Dotfiles', true, bufnr) },
        ['HA'] = { collapse_all, desc('Collapse All', true, bufnr) },
        ['I'] = { Tapi.toggle_gitignore_filter, desc('Toggle Git Ignore', true, bufnr) },
        ['J'] = { Tnode.navigate.sibling.last, desc('Last Sibling', true, bufnr) },
        ['K'] = { Tnode.navigate.sibling.first, desc('First Sibling', true, bufnr) },
        ['O'] = { Tnode.open.no_window_picker, desc('Open: No Window Picker', true, bufnr) },
        ['P'] = { vsplit_preview, desc('Vsplit Preview', true, bufnr) },
        ['R'] = { Tapi.reload, desc('Refresh', true, bufnr) },
        ['S'] = { Tapi.search_node, desc('Search', true, bufnr) },
        ['T'] = { open_tab_silent, desc('Open Tab Silently', true, bufnr) },
        ['U'] = { Tapi.toggle_custom_filter, desc('Toggle Hidden', true, bufnr) },
        ['W'] = { Tapi.collapse_all, desc('Collapse', true, bufnr) },
        ['Y'] = { FsApi.copy.relative_path, desc('Copy Relative Path', true, bufnr) },
        ['[c'] = { Tnode.navigate.git.prev, desc('Prev Git', true, bufnr) },
        ['[e'] = { Tnode.navigate.diagnostics.prev, desc('Prev Diagnostic', true, bufnr) },
        [']c'] = { Tnode.navigate.git.next, desc('Next Git', true, bufnr) },
        [']e'] = { Tnode.navigate.diagnostics.next, desc('Next Diagnostic', true, bufnr) },
        ['a'] = { FsApi.create, desc('Create', true, bufnr) },
        ['bd'] = { TMarks.bulk.delete, desc('Delete Bookmarked', true, bufnr) },
        ['bmv'] = { TMarks.bulk.move, desc('Move Bookmarked', true, bufnr) },
        ['bt'] = { TMarks.bulk.trash, desc('Trash Bookmarked', true, bufnr) },
        ['c'] = { FsApi.copy.node, desc('Copy', true, bufnr) },
        ['d'] = { FsApi.remove, desc('Delete', true, bufnr) },
        ['e'] = { FsApi.rename_basename, desc('Rename: Basename', true, bufnr) },
        ['f'] = { Api.live_filter.start, desc('Filter', true, bufnr) },
        ['g?'] = { Tapi.toggle_help, desc('Help', true, bufnr) },
        ['ga'] = { git_add, desc('Git Add...', true, bufnr) },
        ['gy'] = { FsApi.copy.absolute_path, desc('Copy Absolute Path', true, bufnr) },
        ['m'] = { TMarks.toggle, desc('Toggle Bookmark', true, bufnr) },
        ['o'] = { Tnode.open.edit, desc('Open', true, bufnr) },
        ['p'] = { FsApi.paste, desc('Paste', true, bufnr) },
        ['q'] = { Tapi.close, desc('Close', true, bufnr) },
        ['r'] = { FsApi.rename, desc('Rename', true, bufnr) },
        ['s'] = { Tnode.run.system, desc('Run System', true, bufnr) },
        ['t'] = { swap_then_open_tab, desc('Open Tab', true, bufnr) },
        ['x'] = { FsApi.cut, desc('Cut', true, bufnr) },
        ['y'] = { FsApi.copy.filename, desc('Copy Name', true, bufnr) },
    }

    if vim.o.mouse ~= '' then
        Keys['<2-LeftMouse>'] = { Tnode.open.edit, desc('Open', true, bufnr) }
        Keys['<2-RightMouse>'] = { change_root_to_node, desc('CD', true, bufnr) }
    end

    map_keys(Keys, bufnr)
end

local HEIGHT_RATIO = USE_FLOAT and 6 / 7 or 1
local WIDTH_RATIO = USE_FLOAT and 2 / 3 or 1 / 4

local function label(path)
    path = path:gsub(os.getenv('HOME'), '~', 1)
    return path:gsub('([a-zA-Z])[a-z0-9]+', '%1') .. (path:match('[a-zA-Z]([a-z0-9]*)$') or '')
end

local VIEW_WIDTH_FIXED = 30
local view_width_max = VIEW_WIDTH_FIXED -- fixed to start

-- get current view width
local function get_view_width_max()
    return view_width_max
end

Tree.setup({
    on_attach = on_attach,

    sync_root_with_cwd = true,
    respect_buf_cwd = true,

    prefer_startup_root = false,

    sort = {
        sorter = 'case_sensitive',
        folders_first = false,
        files_first = false,
    },

    auto_reload_on_write = true,

    filesystem_watchers = {
        enable = true,
    },

    update_focused_file = {
        enable = true,

        update_root = {
            enable = true,
        },

        exclude = false,
    },

    actions = {
        use_system_clipboard = false,

        change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
        },

        open_file = {
            quit_on_open = true,
            resize_window = true,

            window_picker = {
                exclude = {
                    filetype = {
                        'notify',
                        'packer',
                        'qf',
                        'diff',
                        'fugitive',
                        'fugitiveblame',
                    },
                    buftype = {
                        'nofile',
                        'terminal',
                        'help',
                    },
                },
            },
        },
    },

    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = false,
    hijack_unnamed_buffer_when_opening = false,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },

    reload_on_bufenter = true,

    view = {
        centralize_selection = true,
        float = {
            enable = USE_FLOAT,
            quit_on_focus_loss = true,
            open_win_config = function()
                local cols = vim.o.columns
                local rows = vim.o.lines
                local cmdh = vim.o.cmdheight

                local screen_w = cols
                local screen_h = rows - cmdh
                local window_w = screen_w * WIDTH_RATIO
                local window_h = screen_h * HEIGHT_RATIO
                local window_w_int = floor(window_w)
                local window_h_int = floor(window_h)
                local center_x = (screen_w - window_w) / 2
                local center_y = ((rows - window_h) / 2) - cmdh

                return {
                    border = 'rounded',
                    relative = 'editor',
                    row = center_y,
                    col = center_x,
                    width = window_w_int,
                    height = window_h_int,
                }
            end,
        },
        -- width = function() return floor(vim.opt.columns:get() * WIDTH_RATIO) end,
        width = get_view_width_max,

        cursorline = true,
        preserve_window_proportions = false,
        number = false,
        signcolumn = 'yes',
    },

    diagnostics = {
        enable = true,

        show_on_dirs = true,
        show_on_open_dirs = true,

        severity = {
            min = D_WARN,
            max = D_ERR,
        },
    },

    modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
    },

    renderer = {
        add_trailing = false,
        full_name = true,

        special_files = {
            '.clang-tidy',
            '.clangd',
            '.editorconfig',
            '.gitignore',
            '.luarc.json',
            '.pre-commit-config.yaml',
            '.pre-commit-config.yml',
            '.stylua.toml',
            '.vscode',
            'Cargo.toml',
            'LICENSE',
            'Makefile',
            'Pipfile',
            'README.md',
            'package.json',
            'requirements.txt',
            'stylua.toml',
        },

        highlight_git = 'icon',
        highlight_diagnostics = 'all',
        highlight_opened_files = 'name',
        highlight_modified = 'all',
        highlight_hidden = 'icon',
        highlight_bookmarks = 'name',

        hidden_display = 'all',

        symlink_destination = true,

        decorators = {
            'Git',
            'Open',
            'Hidden',
            'Modified',
            'Bookmark',
            'Diagnostics',
            'Copied',
            'Cut',
        },

        root_folder_label = label,
        group_empty = label,
        -- group_empty = false,

        indent_width = 2,
        indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
                corner = '└',
                edge = '│',
                item = '│',
                bottom = '─',
                none = ' ',
            },
        },

        icons = {
            web_devicons = {
                file = { enable = true, color = true },
                folder = { enable = true, color = true },
            },

            git_placement = 'signcolumn',
            hidden_placement = 'before',
            modified_placement = 'right_align',
            diagnostics_placement = 'after',
            bookmarks_placement = 'before',

            symlink_arrow = ' ➛ ',
            show = {
                bookmarks = true,
                diagnostics = true,
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
                hidden = false,
                modified = true,
            },

            glyphs = {
                default = '',
                symlink = '',
                bookmark = '󰆤',
                modified = '●',
                folder = {
                    arrow_closed = '',
                    arrow_open = '',
                    default = '',
                    open = '',
                    empty = '',
                    empty_open = '',
                    symlink = '',
                    symlink_open = '',
                },
                git = {
                    unstaged = '✗',
                    staged = '✓',
                    unmerged = '',
                    renamed = '➜',
                    untracked = '★',
                    deleted = '',
                    ignored = '◌',
                },
            },
        },
    },
    filters = {
        dotfiles = false,
        git_ignored = false,
        no_buffer = false,
    },

    tab = {
        sync = {
            open = true,
            close = false,
        },
    },

    live_filter = {
        prefix = '[FILTER]: ',
        always_show_folders = true,
    },

    git = {
        enable = true,
        cygwin_support = is_windows,
        timeout = 500,
        show_on_dirs = true,
        show_on_open_dirs = true,
    },

    help = {
        sort_by = 'desc',
    },

    ui = {
        confirm = {
            remove = true,
            trash = false,
            default_yes = true,
        },
    },
})

-- Auto-open file after creation
Api.events.subscribe(Api.events.Event.FileCreated, function(file)
    vim.cmd.edit(vim.fn.fnameescape(file.fname))
end)

local group = augroup('NvimTree.Au', { clear = true })

---@type AuDict
local au_cmds = {
    ['VimEnter'] = {
        group = group,
        callback = tree_open,
    },
    ['WinClosed'] = {
        group = group,
        nested = true,
        callback = function()
            local nwin = floor(tonumber(fn.expand('<amatch>')))

            local tabc = function()
                return tab_win_close(nwin)
            end

            sched_wp(tabc)
        end,
    },
    ['BufEnter'] = {
        group = group,
        pattern = 'NvimTree*',
        callback = tree_open,
    },
}

au(au_cmds)

---@type HlDict
local hl_groups = {
    ['NvimTreeExecFile'] = { fg = '#ffa0a0' },
    ['NvimTreeSpecialFile'] = { fg = '#ff80ff', underline = true },
    ['NvimTreeSymlink'] = { fg = 'Yellow', italic = false },
    ['NvimTreeImageFile'] = { link = 'Title' },
}

hi(hl_groups)

User.register_plugin('plugin.nvim_tree')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
