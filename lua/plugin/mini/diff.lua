---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.diff',
    version = false,
    opts = {
        view = {
            style = vim.go.number and 'number' or 'sign',
            signs = { add = '▒', change = '▒', delete = '▒' },
            priority = 199,
        },
        source = nil,
        delay = { text_change = 200 },
        mappings = {
            apply = 'gh',
            reset = 'gH',
            textobject = 'gh',
            goto_first = '[H',
            goto_prev = '[h',
            goto_next = ']h',
            goto_last = ']H',
        },
        options = {
            algorithm = 'histogram',
            indent_heuristic = true,
            linematch = 60,
            wrap_goto = false,
        },
    },
    config = function(_, opts)
        require('mini.diff').setup(opts)
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
