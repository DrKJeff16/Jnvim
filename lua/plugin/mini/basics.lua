---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.basics',
    version = false,
    opts = {
        options = { basic = true, extra_ui = true, win_borders = 'rounded' },
        autocommands = { basic = true, relnum_in_visual_mode = false },
        silent = true,
        mappings = {
            basic = false,
            option_toggle_prefix = '',
            windows = true,
            move_with_alt = false,
        },
    },
    config = function(_, opts)
        require('mini.basics').setup(opts)
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
