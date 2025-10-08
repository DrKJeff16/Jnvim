---@module 'lazy'

---@type LazySpec[]
return {
    {
        'equalsraf/neovim-gui-shim',
        version = false,
        cond = not require('user_api.check').in_console(),
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
