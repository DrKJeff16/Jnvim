---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local hl_t = User.types.user.highlight

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
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
local highlight = {}
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

register(HType.HIGHLIGHT_SETUP, apply_Hilite)
register(HType.SCOPE_HIGHLIGHT, Builtin.scope_highlight_from_extmark)

Ibl.setup({
    indent = {
        highlight = highlight,
        char = '•',
    },
    whitespace = {
        highlight = highlight,
        remove_blankline_trail = true,
    },
    scope = { enabled = true },
})

if exists('rainbow-delimiters.setup') then
    vim.g.rainbow_delimiters = { highlight = names }
end
