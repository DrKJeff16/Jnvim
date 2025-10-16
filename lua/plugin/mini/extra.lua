---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.extra',
    version = false,
    config = function()
        require('mini.bufremove').setup({})
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
