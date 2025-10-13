---@module 'lazy'

---@type LazySpec
return {
    'Zeioth/dooku.nvim',
    event = 'VeryLazy',
    version = false,
    opts = {
        project_root = { '.git', '.hg', '.svn', '.bzr', '_darcs', '_FOSSIL_', '.fslckout' },
        browser_cmd = 'xdg-open',
        on_bufwrite_generate = false,
        on_generate_open = true,
        auto_setup = true,
        on_generate_notification = true,
        on_open_notification = true,
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
