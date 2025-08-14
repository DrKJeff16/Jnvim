local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty
local vim_has = Check.exists.vim_has
local type_not_empty = Check.value.type_not_empty
local hi = User.highlight.hl_from_dict

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
    RainbowRed = { fg = '#E06C75' },
    RainbowYellow = { fg = '#E5C07B' },
    RainbowBlue = { fg = '#61AFEF' },
    RainbowOrange = { fg = '#D19A66' },
    RainbowGreen = { fg = '#98C379' },
    RainbowViolet = { fg = '#C678DD' },
    RainbowCyan = { fg = '#56B6C2' },
}

---@type string[]
local highlight = {
    'RainbowRed',
    'RainbowYellow',
    'RainbowBlue',
    'RainbowOrange',
    'RainbowGreen',
    'RainbowViolet',
    'RainbowCyan',
}

---@return boolean
local function breakindent_check()
    return vim_has('nvim-0.10') and vim.opt.breakindent:get() and vim.opt.breakindentopt:get() ~= ''
end

if type_not_empty('table', vim.g.rainbow_delimiters) then
    vim.g.rainbow_delimiters =
        vim.tbl_deep_extend('force', vim.g.rainbow_delimiters, { highlight = highlight })
end

---@param htype string
---@param func fun(...: any): any
---@param opts? ibl.hooks.options
local function reg(htype, func, opts)
    opts = is_tbl(opts) and opts or {}

    if empty(opts) then
        register(htype, func)
    else
        register(htype, func, opts)
    end
end

reg(HType.HIGHLIGHT_SETUP, function()
    hi(Hilite)
end)

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

        repeat_linebreak = breakindent_check(),
        smart_indent_cap = false,
    },

    whitespace = {
        highlight = { 'Whitespace', 'NonText' },
        remove_blankline_trail = false,
    },

    scope = { highlight = highlight },
})

---@type { [1]: string, [2]: (fun(...: any): any), [3]: ibl.hooks.options? }[]
local arg_tbl = {
    {
        HType.ACTIVE,

        ---@param bufnr integer
        ---@return boolean
        function(bufnr)
            return vim.api.nvim_buf_line_count(bufnr) < 5000
        end,
    },
    {
        HType.SCOPE_HIGHLIGHT,
        Builtin.scope_highlight_from_extmark,
    },
    {
        HType.SKIP_LINE,
        Builtin.skip_preproc_lines,
        { bufnr = 0 },
    },
    -- {
    --     HType.WHITESPACE,
    --     Builtin.hide_first_space_indent_level,
    -- },
    -- {
    --     HType.WHITESPACE,
    --     Builtin.hide_first_tab_indent_level,
    -- },
}

for _, t in next, arg_tbl do
    if t[3] ~= nil then
        reg(t[1], t[2], t[3])
    else
        reg(t[1], t[2])
    end
end

User.register_plugin('plugin.ibl')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
