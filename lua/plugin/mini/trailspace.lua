---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.trailspace',
    version = false,
    config = function()
        require('mini.trailspace').setup({ only_in_normal_buffers = true })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
