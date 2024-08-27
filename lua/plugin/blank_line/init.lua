local User = require('user_api')
local Check = User.check
local hl_t = User.types.user.highlight

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty
local hi = User.highlight.hl_from_dict

if not exists('ibl') then
    return
end

User:register_plugin('plugin.blank_line')

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

local function apply_Hilite() hi(Hilite) end

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

---@param htype string
---@param func fun(...)
---@param opts? ibl.hooks.options
local function reg(htype, func, opts)
    opts = is_tbl(opts) and opts or {}

    if empty(opts) then
        register(htype, func)
    else
        register(htype, func, opts)
    end
end

---@type { [1]: string, [2]: fun(...), [3]: table|ibl.hooks.options }[]
local arg_tbl = {
    { HType.ACTIVE, line_cond, {} },
    { HType.HIGHLIGHT_SETUP, apply_Hilite, {} },
    { HType.SCOPE_HIGHLIGHT, Builtin.scope_highlight_from_extmark, {} },
    { HType.SKIP_LINE, Hooks.builtin.skip_preproc_lines, { bufnr = 0 } },
    { HType.WHITESPACE, Hooks.builtin.hide_first_space_indent_level, {} },
    { HType.WHITESPACE, Hooks.builtin.hide_first_tab_indent_level, {} },
}

for _, t in next, arg_tbl do
    reg(t[1], t[2], t[3] or {})
end

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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
