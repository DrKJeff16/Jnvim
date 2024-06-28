---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local hl_t = User.types.user.highlight

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty
local hi = User.highlight.hl

if not exists('ibl') then
    return
end

local Ibl = require('ibl')
local Hooks = require('ibl.hooks')

local HType = Hooks.type
local Builtin = Hooks.builtin

local register = Hooks.register

---@type HlDict
local Hilite = {
    ['RainbowRed'] = { fg = '#E06C75' },
    ['RainbowYellow'] = { fg = '#E5C07B' },
    ['RainbowBlue'] = { fg = '#61AFEF' },
    ['RainbowOrange'] = { fg = '#D19A66' },
    ['RainbowGreen'] = { fg = '#98C379' },
    ['RainbowViolet'] = { fg = '#C678DD' },
    ['RainbowCyan'] = { fg = '#56B6C2' },
}

---@type string[]
local highlight = {
    'Function',
    'Label',
}
for k, _ in next, Hilite do
    if is_str(k) then
        table.insert(highlight, k)
    end
end

---@type string[]
local names = {}
---@type HlOpts[]
local options = {}

for k, v in next, Hilite do
    if is_str(k) and not empty(k) then
        table.insert(names, k)
    end
    if is_tbl(v) and not empty(v) then
        table.insert(options, v)
    end
end

local function apply_Hilite()
    for k, v in next, Hilite do
        hi(k, v)
    end
end

---@param bufnr? integer
---@return boolean
local function line_cond(bufnr)
    return vim.api.nvim_buf_line_count(is_int(bufnr) and bufnr or 0) < 5000
end

local function linebreak_check()
    local vim_has = User.check.exists.vim_has

    return vim_has('nvim-0.10') and vim.opt.breakindent and vim.opt.breakindentopt:get() ~= ''
end

if exists('rainbow-delimiters.setup') then
    vim.g.rainbow_delimiters = { highlight = names }
end

register(HType.ACTIVE, line_cond)
register(HType.HIGHLIGHT_SETUP, apply_Hilite)
register(HType.SCOPE_HIGHLIGHT, Builtin.scope_highlight_from_extmark)
register(HType.SKIP_LINE, Hooks.builtin.skip_preproc_lines, { bufnr = 0 })
register(HType.WHITESPACE, Hooks.builtin.hide_first_space_indent_level)
register(HType.WHITESPACE, Hooks.builtin.hide_first_tab_indent_level)

Ibl.setup({
    enabled = true,
    debounce = 200,
    indent = {
        highlight = highlight,
        -- char = '•',
        char = {
            '╎',
            '╏',
            '┆',
            '┇',
            '┊',
            '┋',
        },
        tab_char = {
            '▏',
            '▎',
            '▍',
            '▌',
            '▋',
            '▊',
            '▉',
            '█',
        },

        repeat_linebreak = linebreak_check(),

        smart_indent_cap = true,
    },
    whitespace = {
        highlight = { 'Whitespace', 'NonText' },
        remove_blankline_trail = true,
    },
    scope = {
        enabled = true,
        show_end = true,
        show_start = true,
        show_exact_scope = true,
        injected_languages = exists('nvim-treesitter'),
        priority = 1024,
        include = {
            node_type = {
                ['*'] = { '*' },
                ['lua'] = { 'return_statement', 'table_constructor' },
            },
        },
    },
})
