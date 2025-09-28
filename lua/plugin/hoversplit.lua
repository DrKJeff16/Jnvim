---@module 'lazy'

---@type LazySpec
return {
    'roobert/hoversplit.nvim',
    dev = true,
    version = false,
    config = function()
        require('hoversplit').setup({
            key_bindings = {
                split_remain_focused = '<leader>hs',
                vsplit_remain_focused = '<leader>hv',
                split = '<leader>hS',
                vsplit = '<leader>hV',
            },
        })
    end,
}
