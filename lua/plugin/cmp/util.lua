local User = require('user_api')
local Check = User.check
local Types = User.types.cmp

local exists = Check.exists.module
local modules = Check.exists.modules
local is_nil = Check.value.is_nil
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

if not exists('cmp') then
    error('Either `cmp` is not installed.')
end

local cmp = require('cmp')

local get_mode = vim.api.nvim_get_mode
local buf_lines = vim.api.nvim_buf_get_lines
local win_cursor = vim.api.nvim_win_get_cursor
local rep_tc = vim.api.nvim_replace_termcodes
local feedkeys = vim.api.nvim_feedkeys
local curr_win = vim.api.nvim_get_current_win

---@type CmpUtil
---@diagnostic disable-next-line:missing-fields
local M = {
    ---@param key string
    ---@param mode MapModes|''
    feedkey = function(key, mode)
        local new_key = rep_tc(key, true, true, true)
        feedkeys(new_key, mode, true)
    end,

    ---@return boolean
    has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(win_cursor(curr_win()))
        return col ~= 0 and buf_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end,

    ---@param opts? cmp.ConfirmationConfig
    ---@return fun(fallback: fun())
    confirm = function(opts)
        opts = is_tbl(opts) and opts or {}
        opts.behavior = not is_nil(opts.behavior) and opts.behavior or cmp.ConfirmBehavior.Replace
        opts.select = is_bool(opts.select) and opts.select or false

        ---@param fallback fun()
        return function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
                cmp.confirm(opts)
            else
                fallback()
            end
        end
    end,

    ---@param fallback fun()
    bs_map = function(fallback)
        if cmp.visible() then
            cmp.close()
        end

        fallback()
    end,
}

---@param fallback fun()
function M.n_select(fallback)
    ---@type cmp.SelectOption
    local opts = { behavior = cmp.SelectBehavior.Insert }

    if cmp.visible() then
        cmp.select_next_item(opts)
    elseif vim.fn['vsnip#available'](1) == 1 then
        M.feedkey('<Plug>(vsnip-expand-or-jump)', '')
    elseif M.has_words_before() then
        cmp.complete()
        if cmp.visible() then
            cmp.select_next_item(opts)
        end
    else
        fallback()
    end
end

---@param fallback fun()
function M.n_shift_select(fallback)
    ---@type cmp.SelectOption
    local opts = { behavior = cmp.SelectBehavior.Replace }

    if cmp.visible() then
        cmp.select_prev_item(opts)
    elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        M.feedkey('<Plug>(vsnip-jump-prev)', '')
    elseif M.has_words_before() then
        cmp.complete()
        if cmp.visible() then
            cmp.select_prev_item(opts)
        end
    else
        fallback()
    end
end

M.tab_map = {
    i = M.n_select,
    s = M.n_select,

    ---@param fallback fun()
    c = function(fallback)
        local opts = { behavior = cmp.SelectBehavior.Insert }

        if cmp.visible() then
            cmp.select_next_item(opts)
        elseif M.has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end,
}

M.s_tab_map = {
    i = M.n_shift_select,
    s = M.n_shift_select,

    ---@param fallback fun()
    c = function(fallback)
        local opts = { behavior = cmp.SelectBehavior.Select }

        if cmp.visible() then
            cmp.select_prev_item(opts)
        elseif M.has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end,
}

M.cr_map = {
    i = M.confirm(),
    s = M.confirm(),
    ---@diagnostic disable-next-line:missing-fields
    c = M.confirm({ select = true }),
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
