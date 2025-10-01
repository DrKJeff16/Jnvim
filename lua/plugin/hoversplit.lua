---@module 'lazy'

---@type LazySpec
return {
    'roobert/hoversplit.nvim',
    version = false,
    opts = {
        key_bindings = {
            split_remain_focused = '<leader>hs',
            vsplit_remain_focused = '<leader>hv',
            split = '<leader>hS',
            vsplit = '<leader>hV',
        },
    },
    config = function(_, opts)
        require('hoversplit').setup(opts)
    end,
}
