---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local maps_t = User.types.user.maps
local kmap = User.maps.kmap
local WK = User.maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local empty = Check.value.empty

if not exists('todo-comments') then
    return
end

local Todo = require('todo-comments')

Todo.setup({
    signs = true, -- show icons in the signs column
    sign_priority = 10, -- sign priority
    -- keywords recognized as todo comments
    keywords = {
        TITLE = {
            icon = '! ',
            color = '#00886d',
            alt = {
                'SECTION',
                'BLOCK',
                'CODESECTION',
                'SECTIONTITLE',
                'CODETITLE',
            },
        },
        FIX = {
            icon = ' ', -- icon used for the sign, and in search results
            color = 'error', -- can be a hex color, or a named color (see below)
            alt = {
                'FIXME',
                'BUG',
                'FIXIT',
                'ISSUE',
                'TOFIX',
                'SOLVE',
                'TOSOLVE',
                'SOLVEIT',
            }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
        },
        TODO = {
            icon = ' ',
            color = 'info',
            alt = { 'PENDING', 'MISSING' },
        },
        HACK = {
            icon = ' ',
            color = 'warning',
            alt = { 'TRICK', 'SOLUTION', 'ADHOC', 'SOLVED' },
        },
        WARN = {
            icon = ' ',
            color = 'warning',
            alt = {
                'WARNING',
                'XXX',
                'PROBLEM',
                'ISSUE',
            },
        },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = {
            icon = ' ',
            color = 'hint',
            alt = {
                'INFO',
                'MINDTHIS',
                'WATCH',
                'ATTENTION',
                'TONOTE',
            },
        },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
    },
    gui_style = {
        fg = 'BOLD', -- The gui style to use for the fg highlight group.
        bg = 'NONE', -- The gui style to use for the bg highlight group.
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 3, -- extra lines that will be re-evaluated when changing a line
        before = '', -- 'fg' or 'bg' or empty
        keyword = 'bg', -- 'fg', 'bg', 'wide', 'wide_bg', 'wide_fg' or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = 'fg', -- 'fg' or 'bg' or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 200, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of highlight groups or use the hex color if hl not found as a fallback
    colors = {
        error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
        warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
        info = { 'DiagnosticInfo', '#2563EB' },
        hint = { 'DiagnosticHint', '#10B981' },
        default = { 'Identifier', '#7C3AED' },
        test = { 'Identifier', '#FF00FF' },
    },
    search = {
        command = 'rg',
        args = {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
})

---@type table<MapModes, KeyMapDict>
local Keys = {
    n = {
        -- `TODO`
        ['<leader>ctn'] = {
            function()
                Todo.jump_next()
            end,
            { desc = "Next 'TODO' Comment" },
        },
        ['<leader>ctp'] = {
            function()
                Todo.jump_prev()
            end,
            { desc = "Previous 'TODO' Comment" },
        },

        -- `ERROR`
        ['<leader>cen'] = {
            function()
                Todo.jump_next({ keywords = { 'ERROR' } })
            end,
            { desc = "Next 'ERROR' Comment" },
        },
        ['<leader>cep'] = {
            function()
                Todo.jump_prev({ keywords = { 'ERROR' } })
            end,
            { desc = "Previous 'ERROR' Comment" },
        },

        -- `WARNING`
        ['<leader>cwn'] = {
            function()
                Todo.jump_next({ keywords = { 'WARNING' } })
            end,
            { desc = "Next 'WARNING' Comment" },
        },
        ['<leader>cwp'] = {
            function()
                Todo.jump_prev({ keywords = { 'WARNING' } })
            end,
            { desc = "Previous 'WARNING' Comment" },
        },
    },
}

---@type table<MapModes, RegKeysNamed>
local Names = {
    n = {
        ['<leader>c'] = { name = '+TODO Comments' },
        ['<leader>cw'] = { name = "+'WARNING'" },
        ['<leader>ce'] = { name = "+'ERROR'" },
        ['<leader>ct'] = { name = "+'TODO'" },
    },
}

for mode, t in next, Keys do
    if WK.available() then
        if is_tbl(Names[mode]) and not empty(Names[mode]) then
            WK.register(Names[mode], { mode = mode })
        end

        WK.register(WK.convert_dict(t), { mode = mode })
    else
        for lhs, v in next, t do
            v[2] = is_tbl(v[2]) and v[2] or {}
            kmap[mode](lhs, v[1], v[2])
        end
    end
end
