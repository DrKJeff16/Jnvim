---@module 'user.types.autopairs'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun

if not exists('nvim-autopairs') then
    return
end

local Ap = require('nvim-autopairs')

Ap.setup({
    active = true,
    disable_filetype = {
        'TelescopePrompt',
        'spectre_panel',
        'checkhealth',
        'help',
        'lazy',
        'NvimTree',
        'packer',
    },

    disable_in_macro = false, -- disable when recording or executing a macro
    disable_in_visualblock = false, -- disable when insert after visual block mode
    disable_in_replace_mode = true,
    enable_moveright = true,
    enable_afterquote = true, -- add bracket pairs after quote
    enable_check_bracket_line = true, --- check bracket in same line
    enable_bracket_in_quote = true,
    enable_abbr = true, -- trigger abbreviation
    break_undo = true, -- switch for basic rule break undo sequence
    check_ts = true,
    ts_config = {
        lua = { 'string', 'source' },
        javascript = false,
        java = false,
    },

    -- ignored_next_char = '[%w%.]',
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], '%s+', ''),

    map_cr = true, -- Map the `<CR>` key
    map_bs = true, -- Map the `<BS>` key
    map_c_h = true, -- Map the `<C-h>` key to delete a pair
    map_c_w = true, -- Map `<C-w>` to delete a pair if possible
    map_char = {
        all = '(',
        tex = '{',
        html = '<',
        markdown = '<',
        xml = '<',
        lua = '<',
        c = '<',
        cpp = '<',
    },

    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
        offset = 0, -- Offset from pattern match
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment',
    },
})

---@type APMods
local M = {
    cmp = function() return exists('plugin.autopairs.cmp', true) end,
    rules = function() return exists('plugin.autopairs.rules', true) end,
}

M.rules()

if exists('cmp') then
    local ap_cmp = M.cmp()

    if is_tbl(ap_cmp) and is_fun(ap_cmp.on) then
        ap_cmp.on()
    end
end

User:register_plugin('plugin.autopairs')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
