---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.test',
    version = false,
    config = function()
        require('mini.test').setup({})
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
