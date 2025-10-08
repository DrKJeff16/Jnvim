---@module 'lazy'

local uv = vim.uv or vim.loop
local in_list = vim.list_contains

---@type LazySpec
return {
    'folke/todo-comments.nvim',
    version = false,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
    },
    cond = function()
        return require('user_api.check.exists').executable('rg')
            and not require('user_api.check').in_console()
    end,
    config = function()
        local desc = require('user_api.maps').desc
        require('todo-comments').setup({
            signs = true, -- show icons in the signs column
            sign_priority = 8, -- sign priority
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
                fg = 'NONE', -- The GUI style to use for the fg highlight group
                bg = 'BOLD', -- The GUI style to use for the bg highlight group
            },

            merge_keywords = true, -- when true, custom keywords will be merged with the defaults

            -- highlighting of the line containing the todo comment
            -- * before: highlights before the keyword (typically comment characters)
            -- * keyword: highlights of the keyword
            -- * after: highlights after the keyword (todo text)
            highlight = {
                multiline = true, -- enable multine todo comments
                multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
                multiline_context = 1, -- extra lines that will be re-evaluated when changing a line
                before = '', -- 'fg' or 'bg' or empty
                keyword = 'wide_fg', -- 'fg', 'bg', 'wide', 'wide_bg', 'wide_fg' or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
                after = 'fg', -- 'fg' or 'bg' or empty
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
        ---@return function
        local function jump(direction, keywords)
            if vim.fn.has('nvim-0.11') == 1 then
                vim.validate('direction', direction, 'string', false, "'next'|'prev'")
                vim.validate('keywords', keywords, 'table', false, 'string[]')
            else
                vim.validate({
                    direction = { direction, 'string' },
                    keywords = { keywords, 'table' },
                })
            end
            if not in_list({ 'next', 'prev' }, direction) then
                error(('(plugin.todo_comments:jump): Invalid direction `%s`!'):format(direction))
            end
            if vim.tbl_isempty(keywords) then
                error('(plugin.todo_comments:jump): No available keywords!')
            end

            local direction_map = {
                next = require('todo-comments').jump_next,
                prev = require('todo-comments').jump_prev,
            }
            return function()
                local func = direction_map[direction]
                func({ keywords = keywords })
            end
        end

        local KEYWORDS = { ---@class TODOKeywords
            TODO = { 'TODO', 'PENDING', 'MISSING' },
            FIX = {
                'FIX',
                'FIXME',
                'BUG',
                'FIXIT',
                'ISSUE',
                'TOFIX',
                'SOLVE',
                'TOSOLVE',
                'SOLVEIT',
            },
            HACK = { 'HACK', 'TRICK', 'SOLUTION', 'ADHOC', 'SOLVED' },
            NOTE = { 'NOTE', 'INFO', 'MINDTHIS', 'TONOTE', 'WATCH' },
            WARN = {
                'WARN',
                'ATTENTION',
                'ISSUE',
                'PROBLEM',
                'WARNING',
                'XXX',
            },
            TITLE = {
                'TITLE',
                'SECTION',
                'BLOCK',
                'CODESECTION',
                'SECTIONTITLE',
                'CODETITLE',
            },
            TEST = { 'TEST', 'TESTING', 'PASSED', 'FAILED' },
            PERF = { 'PERF', 'OPTIM', 'OPTIMIZED', 'PERFORMANCE' },
        }
        require('user_api.config').keymaps({
            n = {
                ['<leader>c'] = { group = '+Comments' },
                ['<leader>cf'] = { group = "+'FIX'" },
                ['<leader>cw'] = { group = "+'WARNING'" },
                ['<leader>ct'] = { group = "+'TODO'" },
                ['<leader>cn'] = { group = "+'NOTE'" },
                ['<leader>ctn'] = { -- `TODO`
                    jump('next', KEYWORDS.TODO),
                    desc("Next 'TODO' Comment"),
                },
                ['<leader>ctp'] = {
                    jump('prev', KEYWORDS.TODO),
                    desc("Previous 'TODO' Comment"),
                },
                ['<leader>cfn'] = { -- `FIX`
                    jump('next', KEYWORDS.FIX),
                    desc("Next 'FIX' Comment"),
                },
                ['<leader>cfp'] = {
                    jump('prev', KEYWORDS.FIX),
                    desc("Previous 'FIX' Comment"),
                },
                ['<leader>cwn'] = { -- `WARNING`
                    jump('next', KEYWORDS.WARN),
                    desc("Next 'WARNING' Comment"),
                },
                ['<leader>cwp'] = {
                    jump('prev', KEYWORDS.WARN),
                    desc("Previous 'WARNING' Comment"),
                },
                ['<leader>cnn'] = { -- `NOTE`
                    jump('next', KEYWORDS.NOTE),
                    desc("Next 'NOTE' Comment"),
                },
                ['<leader>cnp'] = {
                    jump('prev', KEYWORDS.NOTE),
                    desc("Previous 'NOTE' Comment"),
                },
                ['<leader>cl'] = {
                    vim.cmd.TodoLocList,
                    desc('Open Loclist For TODO Comments'),
                },
                ['<leader>cT'] = {
                    function()
                        vim.cmd.TodoTelescope(('keywords=TODO,FIX cwd='):format(uv.cwd()))
                    end,
                    desc('Open TODO Telescope'),
                },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
