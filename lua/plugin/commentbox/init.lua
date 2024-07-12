---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('comment-box') then
    return
end

local CB = require('comment-box')

CB.setup({
    -- type of comments:
    --   - "line":  comment-box will always use line style comments
    --   - "block": comment-box will always use block style comments
    --   - "auto":  comment-box will use block line style comments if
    --              multiple lines are selected, line style comments
    --              otherwise
    comment_style = 'block',
    doc_width = 80, -- width of the document
    box_width = 60, -- width of the boxes
    borders = { -- symbols used to draw a box
        top = '─',
        bottom = '─',
        left = '│',
        right = '│',
        top_left = '╭',
        top_right = '╮',
        bottom_left = '╰',
        bottom_right = '╯',
    },
    line_width = 70, -- width of the lines
    lines = { -- symbols used to draw a line
        line = '─',
        line_start = '─',
        line_end = '─',
        title_left = '─',
        title_right = '─',
    },
    outer_blank_lines_above = false, -- insert a blank line above the box
    outer_blank_lines_below = false, -- insert a blank line below the box
    inner_blank_lines = false, -- insert a blank line above and below the text
    line_blank_line_above = false, -- insert a blank line above the line
    line_blank_line_below = false, -- insert a blank line below the line
})

if exists('which-key') then
    local wk = require('which-key')
    wk.register({
        ['<Leader>'] = {
            c = {
                name = ' □  Boxes',
                b = { '<Cmd>CBccbox<CR>', 'Box Title' },
                t = { '<Cmd>CBllline<CR>', 'Titled Line' },
                l = { '<Cmd>CBline<CR>', 'Simple Line' },
                m = { '<Cmd>CBllbox14<CR>', 'Marked' },
                -- d = { "<Cmd>CBd<CR>", "Remove a box" },
            },
        },
    })
else
    local kmap = User.maps.kmap
    local nmap = kmap.n
    local vmap = kmap.v
    local imap = kmap.i

    -- Titles
    nmap('<Leader>cb', '<Cmd>CBccbox<CR>')
    vmap('<Leader>cb', '<Cmd>CBccbox<CR>')
    -- Named parts
    nmap('<Leader>ct', '<Cmd>CBllline<CR>')
    vmap('<Leader>ct', '<Cmd>CBllline<CR>')
    -- Simple line
    nmap('<Leader>cl', '<Cmd>CBline<CR>')
    imap('<M-l>', '<Cmd>CBline<CR>') -- To use in Insert Mode
    -- Marked comments
    nmap('<Leader>cm', '<Cmd>CBllbox14<CR>')
    vmap('<Leader>cm', '<Cmd>CBllbox14<CR>')
    -- Removing a box is simple enough with the command (CBd), but if you
    -- use it a lot:
    nmap('<Leader>cd', '<Cmd>CBd<CR>')
    vmap('<Leader>cd', '<Cmd>CBd<CR>')
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
