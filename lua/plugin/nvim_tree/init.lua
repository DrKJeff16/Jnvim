---@diagnostic disable:need-check-nil

---@module 'user_api.types.util'

local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty
local type_not_empty = Check.value.type_not_empty
local hi = User.highlight.hl_from_dict
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('nvim-tree') then
    return
end

--- NOTE: Use floating Tree? You decide
local USE_FLOAT = false

local dERROR = vim.diagnostic.severity.ERROR
local dWARN = vim.diagnostic.severity.WARN
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

local FsApi = require('nvim-tree.api').fs
local Tapi = require('nvim-tree.api').tree
local Tnode = require('nvim-tree.api').node

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
-- ---@type AnyFunc
-- local change_root = Tapi.change_root
-- ---@type AnyFunc
-- local change_root_to_parent = Tapi.change_root_to_parent

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

    map_dict(keys, 'wk.register', true, nil, bufnr)
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

    if not is_nil(nodes) then
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

    if not is_nil(nodes) then
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
        vim.cmd('wincmd l')
        tab(node)
    end
end

---@param bufn integer
local on_attach = function(bufn)
    CfgApi.mappings.default_on_attach(bufn)

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
        ['<C-c>'] = {
            change_root_to_global_cwd,
            desc('Change Root To Global CWD', true, bufn),
        },
        ['<C-U>'] = {
            change_root_to_parent,
            desc('Set Root To Upper Dir', true, bufn),
        },
        ['?'] = {
            toggle_help,
            desc('Help', true, bufn),
        },
        ['<C-f>'] = {
            edit_or_open,
            desc('Edit Or Open', true, bufn),
        },
        ['P'] = {
            vsplit_preview,
            desc('Vsplit Preview', true, bufn),
        },
        ['d'] = {
            close,
            desc('Close', true, bufn),
        },
        ['HA'] = {
            collapse_all,
            desc('Collapse All', true, bufn),
        },
        ['ga'] = {
            git_add,
            desc('Git Add...', true, bufn),
        },
        ['t'] = {
            swap_then_open_tab,
            desc('Open Tab', true, bufn),
        },
        ['T'] = {
            open_tab_silent,
            desc('Open Tab Silently', true, bufn),
        },

        -- BEGIN_DEFAULT_ON_ATTACH
        ['-'] = { Tapi.change_root_to_parent, desc('Up', true, bufn) },
        ['.'] = { Tnode.run.cmd, desc('Run Command', true, bufn) },
        ['<'] = { Tnode.navigate.sibling.prev, desc('Previous Sibling', true, bufn) },
        ['<BS>'] = { Tnode.navigate.parent_close, desc('Close Directory', true, bufn) },
        ['<C-]>'] = { Tapi.change_root_to_node, desc('CD', true, bufn) },
        ['<C-d>'] = { FsApi.remove, desc('Delete', true, bufn) },
        ['<C-e>'] = { Tnode.open.replace_tree_buffer, desc('Open: In Place', true, bufn) },
        ['<C-k>'] = { Tnode.show_info_popup, desc('Info', true, bufn) },
        ['<C-r>'] = { FsApi.rename_sub, desc('Rename: Omit Filename', true, bufn) },
        ['<C-t>'] = { Tapi.change_root_to_parent, desc('Change Root To Parent', true, bufn) },
        ['<C-v>'] = { Tnode.open.vertical, desc('Open: Vertical Split', true, bufn) },
        ['<C-x>'] = { Tnode.open.horizontal, desc('Open: Horizontal Split', true, bufn) },
        ['<CR>'] = { Tnode.open.edit, desc('Open', true, bufn) },
        ['<Tab>'] = { Tnode.open.preview, desc('Open Preview', true, bufn) },
        ['>'] = { Tnode.navigate.sibling.next, desc('Next Sibling', true, bufn) },
        ['B'] = { Tapi.toggle_no_buffer_filter, desc('Toggle No Buffer', true, bufn) },
        ['C'] = { Tapi.toggle_git_clean_filter, desc('Toggle Git Clean', true, bufn) },
        ['D'] = { FsApi.trash, desc('Trash', true, bufn) },
        ['E'] = { Tapi.expand_all, desc('Expand All', true, bufn) },
        ['F'] = { Api.live_filter.clear, desc('Clean Filter', true, bufn) },
        ['H'] = { Tapi.toggle_hidden_filter, desc('Toggle Dotfiles', true, bufn) },
        ['I'] = { Tapi.toggle_gitignore_filter, desc('Toggle Git Ignore', true, bufn) },
        ['J'] = { Tnode.navigate.sibling.last, desc('Last Sibling', true, bufn) },
        ['K'] = { Tnode.navigate.sibling.first, desc('First Sibling', true, bufn) },
        ['O'] = { Tnode.open.no_window_picker, desc('Open: No Window Picker', true, bufn) },
        ['R'] = { Tapi.reload, desc('Refresh', true, bufn) },
        ['S'] = { Tapi.search_node, desc('Search', true, bufn) },
        ['U'] = { Tapi.toggle_custom_filter, desc('Toggle Hidden', true, bufn) },
        ['W'] = { Tapi.collapse_all, desc('Collapse', true, bufn) },
        ['Y'] = { FsApi.copy.relative_path, desc('Copy Relative Path', true, bufn) },
        ['[c'] = { Tnode.navigate.git.prev, desc('Prev Git', true, bufn) },
        ['[e'] = { Tnode.navigate.diagnostics.prev, desc('Prev Diagnostic', true, bufn) },
        [']c'] = { Tnode.navigate.git.next, desc('Next Git', true, bufn) },
        [']e'] = { Tnode.navigate.diagnostics.next, desc('Next Diagnostic', true, bufn) },
        ['a'] = { FsApi.create, desc('Create', true, bufn) },
        ['bmv'] = { Api.marks.bulk.move, desc('Move Bookmarked', true, bufn) },
        ['c'] = { FsApi.copy.node, desc('Copy', true, bufn) },
        ['e'] = { FsApi.rename_basename, desc('Rename: Basename', true, bufn) },
        ['f'] = { Api.live_filter.start, desc('Filter', true, bufn) },
        ['g?'] = { Tapi.toggle_help, desc('Help', true, bufn) },
        ['gy'] = { FsApi.copy.absolute_path, desc('Copy Absolute Path', true, bufn) },
        ['m'] = { Api.marks.toggle, desc('Toggle Bookmark', true, bufn) },
        ['o'] = { Tnode.open.edit, desc('Open', true, bufn) },
        ['p'] = { FsApi.paste, desc('Paste', true, bufn) },
        ['q'] = { Tapi.close, desc('Close', true, bufn) },
        ['r'] = { FsApi.rename, desc('Rename', true, bufn) },
        ['s'] = { Tnode.run.system, desc('Run System', true, bufn) },
        ['x'] = { FsApi.cut, desc('Cut', true, bufn) },
        ['y'] = { FsApi.copy.filename, desc('Copy Name', true, bufn) },
    }

    if vim.o.mouse ~= '' then
        Keys['<2-LeftMouse>'] = { Tnode.open.edit, desc('Open', true, bufn) }
        Keys['<2-RightMouse>'] = { Tapi.change_root_to_node, desc('CD', true, bufn) }
    end

    map_keys(Keys, bufn)
end

local HEIGHT_RATIO = USE_FLOAT and 6 / 7 or 1
local WIDTH_RATIO = USE_FLOAT and 2 / 3 or 1 / 4

local function label(path)
    path = path:gsub(os.getenv('HOME'), '~', 1)
    return path:gsub('([a-zA-Z])[a-z0-9]+', '%1') .. (path:match('[a-zA-Z]([a-z0-9]*)$') or '')
end

local VIEW_WIDTH_FIXED = 30
local view_width_max = VIEW_WIDTH_FIXED -- fixed to start

-- toggle the width and redraw
local function toggle_width_adaptive()
    if view_width_max == -1 then
        view_width_max = VIEW_WIDTH_FIXED
    else
        view_width_max = -1
    end

    require('nvim-tree.api').tree.reload()
end

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
        sorter = 'name',
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
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
        },

        open_file = {
            quit_on_open = true,
            resize_window = true,
        },
    },

    system_open = {
        cmd = 'xdg-open',
        args = {},
    },

    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },

    reload_on_bufenter = true,

    view = {
        float = {
            enable = USE_FLOAT,
            quit_on_focus_loss = true,
            open_win_config = function()
                local cols = vim.opt.columns:get()
                local rows = vim.opt.lines:get()
                local cmdh = vim.opt.cmdheight:get()

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
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = 'yes',
    },

    diagnostics = {
        enable = true,
        severity = {
            min = dWARN,
            max = dERROR,
        },
        icons = {
            hint = '',
            info = '',
            warning = '',
            error = '',
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

        symlink_destination = true,

        icons = {
            web_devicons = {
                file = { enable = true, color = true },
                folder = { enable = true, color = true },
            },

            git_placement = 'signcolumn',
            modified_placement = 'before',
            diagnostics_placement = 'after',
            bookmarks_placement = 'before',

            symlink_arrow = ' ➛ ',
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
                modified = true,
                diagnostics = true,
                bookmarks = true,
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
})

-- Auto-open file after creation
Api.events.subscribe(Api.events.Event.FileCreated, function(file)
    vim.cmd.edit(vim.fn.fnameescape(file.fname))
end)

---@type AuDict
local au_cmds = {
    ['VimEnter'] = {
        group = augroup('NvimTree.Au', { clear = false }),
        callback = tree_open,
    },
    ['WinClosed'] = {
        group = augroup('NvimTree.Au', { clear = false }),
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
        group = augroup('NvimTree.Au', { clear = false }),
        pattern = 'NvimTree*',
        callback = tree_open,
    },
}

User.util.au.au_from_dict(au_cmds)

---@type HlDict
local hl_groups = {
    ['NvimTreeExecFile'] = { fg = '#ffa0a0' },
    ['NvimTreeSpecialFile'] = { fg = '#ff80ff', underline = true },
    ['NvimTreeSymlink'] = { fg = 'Yellow', italic = false },
    ['NvimTreeImageFile'] = { link = 'Title' },
}

hi(hl_groups)

User:register_plugin('plugin.nvim_tree')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
