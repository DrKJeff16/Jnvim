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
        indent = { enabled = true },
        input = { enabled = true },
        layout = { enabled = true },
    },
}
