local User = require('user_api')
local Check = User.check
local WK = User.maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local empty = Check.value.empty
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('todo-comments') then
    return
end

User:register_plugin('plugin.todo_comments')

local TODO = require('todo-comments')

-- TODO: Test
TODO.setup({
    signs = true, -- show icons in the signs column
    sign_priority = 80, -- sign priority
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
                'ATTENTION',
                'ISSUE',
                'PROBLEM',
                'WARNING',
                'XXX',
            },
        },
        PERF = {
            icon = ' ',
            color = 'info',
            alt = {
                'OPTIM',
                'OPTIMIZED',
                'PERFORMANCE',
            },
        },
        NOTE = {
            icon = ' ',
            color = 'hint',
            alt = {
                'INFO',
                'MINDTHIS',
                'TONOTE',
                'WATCH',
            },
        },
        TEST = {
            icon = '⏲ ',
            color = 'test',
            alt = {
                'TESTING',
                'PASSED',
                'FAILED',
            },
        },
    },
    gui_style = {
        fg = 'BOLD', -- The gui style to use for the fg highlight group
        bg = 'NONE', -- The gui style to use for the bg highlight group
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
        keyword = 'wide_fg', -- 'fg', 'bg', 'wide', 'wide_bg', 'wide_fg' or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = '', -- 'fg' or 'bg' or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 250, -- ignore lines longer than this
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
    },
})

---@param direction 'next'|'prev'
---@param keywords string[]
---@return fun()
local function jump(direction, keywords)
    if not (is_str(direction) or vim.tbl_contains({ 'next', 'prev' }, direction)) then
        error('(plugin.todo_comments:jump): Invalid direction')
    end

    local direction_map = {
        next = TODO.jump_next,
        prev = TODO.jump_prev,
    }

    return function() direction_map[direction]({ keywords = keywords }) end
end

---@type KeyMapDict
local Keys = {
    -- `TODO`
    ['<leader>ctn'] = {
        jump('next', { 'TODO' }),
        desc("Next 'TODO' Comment"),
    },
    ['<leader>ctp'] = {
        jump('prev', { 'TODO' }),
        desc("Previous 'TODO' Comment"),
    },

    -- `ERROR`
    ['<leader>cen'] = {
        jump('next', { 'ERROR' }),
        desc("Next 'ERROR' Comment"),
    },
    ['<leader>cep'] = {
        jump('prev', { 'ERROR' }),
        desc("Previous 'ERROR' Comment"),
    },

    -- `WARNING`
    ['<leader>cwn'] = {
        jump('next', { 'WARNING' }),
        desc("Next 'WARNING' Comment"),
    },
    ['<leader>cwp'] = {
        jump('prev', { 'WARNING' }),
        desc("Previous 'WARNING' Comment"),
    },

    -- `NOTE`
    ['<leader>cnn'] = {
        jump('next', { 'NOTE' }),
        desc("Next 'NOTE' Comment"),
    },
    ['<leader>cnp'] = {
        jump('prev', { 'NOTE' }),
        desc("Previous 'NOTE' Comment"),
    },
}

---@type RegKeysNamed
local Names = {
    ['<leader>c'] = { group = '+Comments' },
    ['<leader>cw'] = { group = "+'WARNING'" },
    ['<leader>ce'] = { group = "+'ERROR'" },
    ['<leader>ct'] = { group = "+'TODO'" },
    ['<leader>cn'] = { group = "+'NOTE'" },
}

if WK.available() then
    map_dict(Names, 'wk.register', false, 'n')
    map_dict(Names, 'wk.register', false, 'v')
end
map_dict(Keys, 'wk.register', false, 'n')
map_dict(Keys, 'wk.register', false, 'v')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
