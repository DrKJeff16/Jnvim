---@module 'lazy'

---@type LazySpec
return {
    'gbprod/yanky.nvim',
    version = false,
    dependencies = { 'kkharji/sqlite.lua', 'nvim-telescope/telescope.nvim' },
    opts = {
        ring = {
            history_length = 100,
            storage = 'shada',
            storage_path = vim.fn.stdpath('data') .. '/databases/yanky.db',
            sync_with_numbered_registers = true,
            cancel_event = 'update',
            ignore_registers = { '_' },
            update_register_on_cycle = false,
            permanent_wrapper = nil,
        },
        picker = {
            select = { action = nil }, -- nil to use default put action
            telescope = { use_default_mappings = true }, -- if default mappings should be used
        },
        system_clipboard = { sync_with_ring = true, clipboard_register = nil },
        highlight = { on_put = true, on_yank = true, timer = 200 },
        preserve_cursor_position = { enabled = true },
        textobj = { enabled = true },
    },
    config = function(_, opts)
        require('yanky').setup(opts)
        require('telescope').load_extension('yank_history')

        vim.keymap.set({ 'o', 'x' }, 'iy', function()
            require('yanky.textobj').last_put()
        end, {})
    end,
    keys = {
        {
            '<leader>P',
            '<CMD>YankyRingHistory<CR>',
            mode = { 'n', 'x' },
            desc = 'Open Yank History',
        },
        { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
        {
            'p',
            '<Plug>(YankyPutAfter)',
            mode = { 'n', 'x' },
            desc = 'Put yanked text after cursor',
        },
        {
            'P',
            '<Plug>(YankyPutBefore)',
            mode = { 'n', 'x' },
            desc = 'Put yanked text before cursor',
        },
        {
            'gp',
            '<Plug>(YankyGPutAfter)',
            mode = { 'n', 'x' },
            desc = 'Put yanked text after selection',
        },
        {
            'gP',
            '<Plug>(YankyGPutBefore)',
            mode = { 'n', 'x' },
            desc = 'Put yanked text before selection',
        },
        {
            '<c-p>',
            '<Plug>(YankyPreviousEntry)',
            desc = 'Select previous entry through yank history',
        },
        { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
        {
            ']p',
            '<Plug>(YankyPutIndentAfterLinewise)',
            desc = 'Put indented after cursor (linewise)',
        },
        {
            '[p',
            '<Plug>(YankyPutIndentBeforeLinewise)',
            desc = 'Put indented before cursor (linewise)',
        },
        {
            ']P',
            '<Plug>(YankyPutIndentAfterLinewise)',
            desc = 'Put indented after cursor (linewise)',
        },
        {
            '[P',
            '<Plug>(YankyPutIndentBeforeLinewise)',
            desc = 'Put indented before cursor (linewise)',
        },
        { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and indent right' },
        { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and indent left' },
        { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
        { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put before and indent left' },
        { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put after applying a filter' },
        { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put before applying a filter' },
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
