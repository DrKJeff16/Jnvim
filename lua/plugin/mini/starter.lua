---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.starter',
    version = false,
    config = function()
        local starter = require('mini.starter')
        starter.setup({
            autoopen = true,
            header = nil,
            footer = nil,
            query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
            silent = false,
            evaluate_single = true,
            items = {
                { name = 'Projects', action = 'Project', section = 'Projects' },
                { name = 'Recent Projects', action = 'ProjectRecents', section = 'Projects' },
                starter.sections.telescope(),
            },
            content_hooks = {
                starter.gen_hook.adding_bullet(),
                starter.gen_hook.aligning('center', 'center'),
            },
        })
    end,
}
