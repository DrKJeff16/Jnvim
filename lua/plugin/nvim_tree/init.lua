local User = require('user_api')
local Check = User.check
local types = User.types.nvim_tree
local WK = User.maps.wk

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun
local is_num = Check.value.is_num
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local is_str = Check.value.is_str
local empty = Check.value.empty
local hi = User.highlight.hl_from_dict
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('nvim-tree') then
    return
end

User.register_plugin('plugin.nvim_tree')

--- Use floating Tree? You decide
local USE_FLOAT = false

local api = vim.api
local opt = vim.opt
local fn = vim.fn
local bo = vim.bo

local sched = vim.schedule
local sched_wp = vim.schedule_wrap
local in_tbl = vim.tbl_contains
local filter = vim.tbl_filter
local tbl_map = vim.tbl_map

local augroup = api.nvim_create_augroup
local get_tabpage = api.nvim_win_get_tabpage
local get_bufn = api.nvim_win_get_buf
local win_list = api.nvim_tabpage_list_wins
local close_win = api.nvim_win_close
local list_wins = api.nvim_list_wins

local floor = math.floor

local Tree = require('nvim-tree')
local View = require('nvim-tree.view')
local Api = require('nvim-tree.api')

local Tapi = Api.tree
local Tnode = Api.node
local CfgApi = Api.config

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
local change_root = Tapi.change_root
---@type AnyFunc
local change_root_to_parent = Tapi.change_root_to_parent
---@type AnyFunc
local reload = Tapi.reload
---@type AnyFunc
local get_node = Tapi.get_node_under_cursor
---@type AnyFunc
local collapse_all = Tapi.collapse_all

---@type fun(keys: KeyMapDict, bufnr: integer|nil?)
local function map_keys(keys, bufnr)
    if not is_tbl(keys) or empty(keys) then
        return
    end

    bufnr = is_int(bufnr) and bufnr or nil

    for _, mode in next, { 'n', 'v' } do
        if WK.available() then
            map_dict(
                { ['<leader>ft'] = { group = '+NvimTree' } },
                'wk.register',
                false,
                mode,
                bufnr or nil
            )
        end
        map_dict(keys, 'wk.register', false, mode, bufnr or nil)
    end
end

---@type KeyMapDict
local my_maps = {
    ['<leader>fto'] = {
        open,
        desc('Open NvimTree'),
    },
    ['<leader>ftt'] = {
        toggle,
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

map_keys(my_maps)

---@param nwin? integer
local function tab_win_close(nwin)
    nwin = is_int(nwin) and nwin or vim.api.nvim_get_current_tabpage()

    local ntab = get_tabpage(nwin)
    local nbuf = get_bufn(nwin)
    local buf_info = fn.getbufinfo(nbuf)[1]

    local tab_wins = filter(function(w) return w - nwin end, win_list(ntab))
    local tab_bufs = tbl_map(get_bufn, tab_wins)

    if buf_info.name:match('.*NvimTree_%d*$') and not empty(tab_bufs) then
        close()
    elseif #tab_bufs == 1 then
        local lbuf_info = fn.getbufinfo(tab_bufs[1])[1]

        if lbuf_info.name:match('.*NvimTree_%d*$') then
            sched(function()
                if #list_wins() == 1 then
                    vim.cmd('quit')
                else
                    close_win(tab_wins[1], true)
                end
            end)
        end
    end
end

---@param data BufData
local function tree_open(data)
    if not (is_str(data.file)) or empty(data.file) then
        return
    end

    local nbuf = data.buf
    local name = data.file

    local buf = vim.bo[nbuf]

    local real = fn.filereadable(name) == 1
    local no_name = name == '' and buf.buftype == ''
    local dir = fn.isdirectory(name) == 1

    if not (real or no_name) then
        return
    end

    local ft = buf.ft
    local noignore = {}

    if ft == '' or empty(noignore) or not in_tbl(noignore, ft) then
        return
    end

    ---@type TreeToggleOpts
    local toggle_opts = { focus = false, find_file = true }

    ---@type TreeOpenOpts
    local open_opts = { find_file = true }

    if dir then
        vim.cmd('cd ' .. name)
        open()
    else
        toggle(toggle_opts)
    end
end

local function edit_or_open()
    ---@type AnyFunc
    local edit = Tnode.open.edit

    ---@type TreeNode
    local node = get_node()
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
        if is_tbl(ngs.dir.direct) and not empty(ngs.dir.direct) then
            gs = ngs.dir.direct[1]
        elseif is_tbl(ngs.dir.indirect) and not empty(ngs.dir.indirect) then
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

---@type fun(bufn: integer)
local on_attach = function(bufn)
    CfgApi.mappings.default_on_attach(bufn)

    ---@type KeyMapDict
    local keys = {
        ['<C-U>'] = {
            change_root_to_parent,
            desc('Set Root To Upper Dir'),
        },
        ['?'] = {
            toggle_help,
            desc('Help'),
        },
        ['<C-f>'] = {
            edit_or_open,
            desc('Edit Or Open'),
        },
        ['P'] = {
            vsplit_preview,
            desc('Vsplit Preview'),
        },
        ['c'] = {
            close,
            desc('Close'),
        },
        ['HA'] = {
            collapse_all,
            desc('Collapse All'),
        },
        ['ga'] = {
            git_add,
            desc('Git Add...'),
        },
        ['t'] = {
            swap_then_open_tab,
            desc('Open Tab'),
        },
    }

    map_keys(keys, bufn)
end

local HEIGHT_RATIO = USE_FLOAT and 6 / 7 or 1.
local WIDTH_RATIO = USE_FLOAT and 2 / 3 or 3 / 7

Tree.setup({
    on_attach = on_attach,

    sort = {
        sorter = 'name',
        folders_first = false,
        files_first = false,
    },

    auto_reload_on_write = true,

    update_focused_file = {
        enable = true,
        update_root = {
            enable = true,
        },
        exclude = false,
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
        width = function() return floor(vim.opt.columns:get() * WIDTH_RATIO) end,

        cursorline = true,
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = vim.opt_local.signcolumn:get(),
    },

    diagnostics = {
        enable = true,
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR,
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
        show_on_open_dirs = false,
    },

    renderer = {
        group_empty = false,
        add_trailing = false,
        full_name = true,

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

if exists('telescope') then
    local Fs = Api.fs
    local tree_actions = {
        {
            name = 'Create node',
            handler = Fs.create,
        },
        {
            name = 'Remove node',
            handler = Fs.remove,
        },
        {
            name = 'Trash node',
            handler = Fs.trash,
        },
        {
            name = 'Rename node',
            handler = Fs.rename,
        },
        {
            name = 'Fully rename node',
            handler = Fs.rename_sub,
        },
        {
            name = 'Copy',
            handler = Fs.copy.node,
        },

        -- ... other custom actions you may want to display in the menu
    }

    local function tree_actions_menu(node)
        local Finders = require('telescope.finders')
        local Pickers = require('telescope.pickers')
        local Sorters = require('telescope.sorters')

        local entry_maker = function(menu_item)
            return {
                value = menu_item,
                ordinal = menu_item.name,
                display = menu_item.name,
            }
        end

        local finder = Finders.new_table({
            results = tree_actions,
            entry_maker = entry_maker,
        })

        local sorter = Sorters.get_generic_fuzzy_sorter()

        local default_options = {
            finder = finder,
            sorter = sorter,
            attach_mappings = function(prompt_buffer_number)
                local actions = require('telescope.actions')

                -- On item select
                actions.select_default:replace(function()
                    local state = require('telescope.actions.state')
                    local selection = state.get_selected_entry()

                    -- Closing the picker
                    actions.close(prompt_buffer_number)
                    -- Executing the callback
                    selection.value.handler(node)
                end)

                -- The following actions are disabled in this example
                -- You may want to map them too depending on your needs though
                -- actions.add_selection:replace(function() end)
                -- actions.remove_selection:replace(function() end)
                -- actions.toggle_selection:replace(function() end)
                -- actions.select_all:replace(function() end)
                -- actions.drop_all:replace(function() end)
                -- actions.toggle_all:replace(function() end)

                return true
            end,
        }

        -- Opening the menu
        Pickers.new({ prompt_title = 'Tree Menu' }, default_options):find()
    end
end

-- Auto-open file after creation
--[[ Api.events.subscribe(Api.events.Event.FileCreated, function(file)
	vim.cmd('ed ' .. file.fname)
end) ]]

---@type HlDict
local hl_groups = {
    ['NvimTreeExecFile'] = { fg = '#ffa0a0' },
    ['NvimTreeSpecialFile'] = { fg = '#ff80ff', underline = true },
    ['NvimTreeSymlink'] = { fg = 'Yellow', italic = true },
    ['NvimTreeImageFile'] = { link = 'Title' },
}

---@type AuDict
local au_cmds = {
    ['VimEnter'] = { callback = tree_open },
    ['WinClosed'] = {
        nested = true,
        callback = function()
            local nwin = math.floor(tonumber(fn.expand('<amatch>')))

            local tabc = function() return tab_win_close(nwin) end

            sched_wp(tabc)
        end,
    },
    ['VimResized'] = {
        group = augroup('NvimTreeResize', { clear = true }),
        callback = function()
            local V = require('nvim-tree.view')
            local A = require('nvim-tree.api').tree
            if V.is_visible() then
                V.close()
                A.open()
            end
        end,
    },
    --[[ ['WinEnter'] = {
        callback = function()

        end,
    } ]]
}

User.util.au.au_from_dict(au_cmds)
hi(hl_groups)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
