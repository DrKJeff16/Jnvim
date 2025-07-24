local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('orgmode') then
    return
end

local Orgmode = require('orgmode')

local ORG_PFX = vim.fn.expand('~/.org')

Orgmode.setup({
    org_startup_indented = true,
    org_adapt_indentation = true,

    org_agenda_files = ORG_PFX .. '/**/*',

    org_default_notes_file = ORG_PFX .. '/default.org',

    org_highlight_latex_and_related = 'native',

    org_todo_keywords = { 'TODO', 'WAITING', '|', 'DONE', 'DELEGATED' },
    org_todo_repeat_to_state = nil,
    org_todo_keyword_faces = {
        WAITING = ':foreground blue :weight bold',
        DELEGATED = ':background #FFFFFF :underline on',
    },

    org_hide_leading_stars = false,
    org_hide_emphasis_markers = false,

    org_ellipsis = '...',

    win_split_mode = function(name)
        -- Make sure it's not a scratch buffer by passing false as 2nd argument
        local bufnr = vim.api.nvim_create_buf(false, false)
        --- Setting buffer name is required
        vim.api.nvim_buf_set_name(bufnr, name)

        local fill = 0.8
        local width = math.floor((vim.o.columns * fill))
        local height = math.floor((vim.o.lines * fill))
        local row = math.floor((((vim.o.lines - height) / 2) - 1))
        local col = math.floor(((vim.o.columns - width) / 2))

        vim.api.nvim_open_win(bufnr, true, {
            relative = 'editor',
            width = width,
            height = height,
            row = row,
            col = col,
            style = 'minimal',
            border = 'rounded',
        })
    end,

    win_border = 'single',

    org_startup_folded = 'showeverything',

    org_babel_default_header_args = { [':tangle'] = 'no', [':noweb'] = 'no' },

    calendar_week_start_day = 0,
})

User.register_plugin('plugin.orgmode')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
