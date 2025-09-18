---@module 'lazy'
---@module 'snacks'

---@type LazySpec
return {
    'folke/snacks.nvim',
    lazy = false,
    version = false,
    priority = 1000,

    ---@type snacks.Config
    opts = {
        animate = { enabled = true },
        dim = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        layout = { enabled = true },
        notifier = { enabled = true },
        statuscolumn = { enabled = true },
        styles = {
            notification = {
                wo = { wrap = true }, -- Wrap notifications
            },
        },
        words = { enabled = true },
    },
}
