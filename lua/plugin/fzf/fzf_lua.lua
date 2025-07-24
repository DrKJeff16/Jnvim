local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable

if not (exists('fzf-lua') and executable('fzf')) then
    return
end

local Fzf = require('fzf-lua')
local Actions = Fzf.actions

Actions = {
    -- Below are the default actions, setting any value in these tables will override
    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
    files = {
        true, -- uncomment to inherit all the below in your custom config
        -- Pickers inheriting these actions:
        --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
        --   tags, btags, args, buffers, tabs, lines, blines
        -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
        -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
        -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
        ['enter'] = Actions.file_edit_or_qf,
        ['ctrl-s'] = Actions.file_split,
        ['ctrl-v'] = Actions.file_vsplit,
        ['ctrl-t'] = Actions.file_tabedit,
        ['alt-q'] = Actions.file_sel_to_qf,
        ['alt-Q'] = Actions.file_sel_to_ll,
        ['alt-i'] = Actions.toggle_ignore,
        ['alt-h'] = Actions.toggle_hidden,
        ['alt-f'] = Actions.toggle_follow,
    },
}

Fzf.setup({
    globals = {
        file_icon_padding = '',

        help_open_win = vim.api.nvim_open_win,
    },

    winopts = {
        -- split = "belowright new",-- open in a split instead?
        -- "belowright new"  : split below
        -- "aboveleft new"   : split above
        -- "belowright vnew" : split right
        -- "aboveleft vnew   : split left
        -- Only valid when using a float window
        -- (i.e. when 'split' is not defined, default)
        height = 0.85, -- window height
        width = 0.80, -- window width
        row = 0.35, -- window row position (0=top, 1=bottom)
        col = 0.50, -- window col position (0=left, 1=right)
        -- border argument passthrough to nvim_open_win()
        border = 'rounded',
        -- Backdrop opacity, 0 is fully opaque, 100 is fully transparent (i.e. disabled)
        backdrop = 60,
        -- title         = "Title",
        -- title_pos     = "center",        -- 'left', 'center' or 'right'
        -- title_flags   = false,           -- uncomment to disable title flags
        fullscreen = false, -- start fullscreen?
        -- enable treesitter highlighting for the main fzf window will only have
        -- effect where grep like results are present, i.e. "file:line:col:text"
        -- due to highlight color collisions will also override `fzf_colors`
        -- set `fzf_colors=false` or `fzf_colors.hl=...` to override
        treesitter = {
            enabled = true,
            fzf_colors = { ['hl'] = '-1:reverse', ['hl+'] = '-1:reverse' },
        },
        preview = {
            -- default     = 'bat',           -- override the default previewer?
            -- default uses the 'builtin' previewer
            border = 'rounded', -- preview border: accepts both `nvim_open_win`
            -- and fzf values (e.g. "border-top", "none")
            -- native fzf previewers (bat/cat/git/etc)
            -- can also be set to `fun(winopts, metadata)`
            wrap = false, -- preview line wrap (fzf's 'wrap|nowrap')
            hidden = false, -- start preview hidden
            vertical = 'down:45%', -- up|down:size
            horizontal = 'right:60%', -- right|left:size
            layout = 'flex', -- horizontal|vertical|flex
            flip_columns = 100, -- #cols to switch to horizontal on flex
            -- Only used with the builtin previewer:
            title = true, -- preview border title (file/buf)?
            title_pos = 'center', -- left|center|right, title alignment
            scrollbar = 'float', -- `false` or string:'float|border'
            -- float:  in-window floating border
            -- border: in-border "block" marker
            scrolloff = -1, -- float scrollbar offset from right
            -- applies only when scrollbar = 'float'
            delay = 20, -- delay(ms) displaying the preview
            -- prevents lag on fast scrolling
            winopts = { -- builtin previewer window options
                number = true,
                relativenumber = false,
                cursorline = true,
                cursorlineopt = 'both',
                cursorcolumn = false,
                signcolumn = 'no',
                list = false,
                foldenable = false,
                foldmethod = 'manual',
            },
        },
        on_create = function()
            -- called once upon creation of the fzf main window
            -- can be used to add custom fzf-lua mappings, e.g:
            --   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
        end,
        -- called once _after_ the fzf interface is closed
        -- on_close = function() ... end
    },

    keymap = {
        -- Below are the default binds, setting any value in these tables will override
        -- the defaults, to inherit from the defaults change [1] from `false` to `true`
        builtin = {
            -- neovim `:tmap` mappings for the fzf win
            true, -- uncomment to inherit all the below in your custom config
            ['<M-Esc>'] = 'hide', -- hide fzf-lua, `:FzfLua resume` to continue
            ['<F1>'] = 'toggle-help',
            ['<F2>'] = 'toggle-fullscreen',
            -- Only valid with the 'builtin' previewer
            ['<F3>'] = 'toggle-preview-wrap',
            ['<F4>'] = 'toggle-preview',
            -- Rotate preview clockwise/counter-clockwise
            ['<F5>'] = 'toggle-preview-ccw',
            ['<F6>'] = 'toggle-preview-cw',
            -- `ts-ctx` binds require `nvim-treesitter-context`
            ['<F7>'] = 'toggle-preview-ts-ctx',
            ['<F8>'] = 'preview-ts-ctx-dec',
            ['<F9>'] = 'preview-ts-ctx-inc',
            ['<S-Left>'] = 'preview-reset',
            ['<S-down>'] = 'preview-page-down',
            ['<S-up>'] = 'preview-page-up',
            ['<M-S-down>'] = 'preview-down',
            ['<M-S-up>'] = 'preview-up',
        },
        fzf = {
            -- fzf '--bind=' options
            true, -- uncomment to inherit all the below in your custom config
            ['ctrl-z'] = 'abort',
            ['ctrl-u'] = 'unix-line-discard',
            ['ctrl-f'] = 'half-page-down',
            ['ctrl-b'] = 'half-page-up',
            ['ctrl-a'] = 'beginning-of-line',
            ['ctrl-e'] = 'end-of-line',
            ['alt-a'] = 'toggle-all',
            ['alt-g'] = 'first',
            ['alt-G'] = 'last',
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ['f3'] = 'toggle-preview-wrap',
            ['f4'] = 'toggle-preview',
            ['shift-down'] = 'preview-page-down',
            ['shift-up'] = 'preview-page-up',
        },
    },

    actions = Actions,

    fzf_opts = {
        -- options are sent as `<left>=<right>`
        -- set to `false` to remove a flag
        -- set to `true` for a no-value flag
        -- for raw args use `fzf_args` instead
        ['--ansi'] = true,
        ['--info'] = 'inline-right', -- fzf < v0.42 = "inline"
        ['--height'] = '100%',
        ['--layout'] = 'reverse',
        ['--border'] = 'none',
        ['--highlight-line'] = true, -- fzf >= v0.53
    },

    -- Only used when fzf_bin = "fzf-tmux", by default opens as a
    -- popup 80% width, 80% height (note `-p` requires tmux > 3.2)
    -- and removes the sides margin added by `fzf-tmux` (fzf#3162)
    -- for more options run `fzf-tmux --help`
    -- NOTE: since fzf v0.53 / sk v0.15 it is recommended to use
    -- native tmux integration by adding the below to `fzf_opts`
    -- fzf_opts = { ["--tmux"] = "center,80%,60%" }
    fzf_tmux_opts = { ['-p'] = '80%,80%', ['--margin'] = '0,0' },

    -- Set fzf's terminal colorscheme (optional)
    --
    -- Set to `true` to automatically generate an fzf's colorscheme from
    -- Neovim's current colorscheme:
    -- ---
    fzf_colors = true,

    hls = {
        normal = 'Normal', -- highlight group for normal fg/bg
        preview_normal = 'Normal', -- highlight group for preview fg/bg
    },

    previewers = {
        cat = {
            cmd = 'cat',
            args = '-n',
        },
        bat = {
            cmd = 'bat',
            args = '--color=always --style=numbers,changes',
        },
        head = {
            cmd = 'head',
            args = nil,
        },
        git_diff = {
            -- if required, use `{file}` for argument positioning
            -- e.g. `cmd_modified = "git diff --color HEAD {file} | cut -c -30"`
            cmd_deleted = 'git diff --color HEAD --',
            cmd_modified = 'git diff --color HEAD',
            cmd_untracked = 'git diff --color --no-index /dev/null',
            -- git-delta is automatically detected as pager, set `pager=false`
            -- to disable, can also be set under 'git.status.preview_pager'
        },
        man = {
            -- NOTE: remove the `-c` flag when using man-db
            -- replace with `man -P cat %s | col -bx` on OSX
            cmd = 'man -c %s | col -bx',
        },
        builtin = {
            syntax = true, -- preview syntax highlight?
            syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
            syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
            limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
            -- previewer treesitter options:
            -- enable specific filetypes with: `{ enabled = { "lua" } }
            -- exclude specific filetypes with: `{ disabled = { "lua" } }
            -- disable `nvim-treesitter-context` with `context = false`
            -- disable fully with: `treesitter = false` or `{ enabled = false }`
            treesitter = {
                enabled = true,
                disabled = {},
                -- nvim-treesitter-context config options
                context = { max_lines = 1, trim_scope = 'inner' },
            },
            -- By default, the main window dimensions are calculated as if the
            -- preview is visible, when hidden the main window will extend to
            -- full size. Set the below to "extend" to prevent the main window
            -- from being modified when toggling the preview.
            toggle_behavior = 'default',
            -- Title transform function, by default only displays the tail
            -- title_fnamemodify = function(s) return vim.fn.fnamemodify(s, ":t") end,
            -- preview extensions using a custom shell command:
            -- for example, use `viu` for image previews
            -- will do nothing if `viu` isn't executable
            extensions = {
                -- neovim terminal only supports `viu` block output
                ['png'] = { 'viu', '-b' },
                -- by default the filename is added as last argument
                -- if required, use `{file}` for argument positioning
                ['svg'] = { 'chafa', '{file}' },
                ['jpg'] = { 'ueberzug' },
            },
            -- if using `ueberzug` in the above extensions map
            -- set the default image scaler, possible scalers:
            --   false (none), "crop", "distort", "fit_contain",
            --   "contain", "forced_cover", "cover"
            -- https://github.com/seebye/ueberzug
            ueberzug_scaler = 'cover',
            -- render_markdown.nvim integration, enabled by default for markdown
            render_markdown = { enabled = true, filetypes = { ['markdown'] = true } },
            -- snacks.images integration, enabled by default
            snacks_image = { enabled = true, render_inline = true },
        },
        -- Code Action previewers, default is "codeaction" (set via `lsp.code_actions.previewer`)
        -- "codeaction_native" uses fzf's native previewer, recommended when combined with git-delta
        codeaction = {
            -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
            diff_opts = { ctxlen = 3 },
        },
        codeaction_native = {
            diff_opts = { ctxlen = 3 },
            -- git-delta is automatically detected as pager, set `pager=false`
            -- to disable, can also be set under 'lsp.code_actions.preview_pager'
            -- recommended styling for delta
            pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
        },
    },
})

User.register_plugin('plugin.fzf.fzf_lua')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
