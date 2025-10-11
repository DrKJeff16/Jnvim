---@module 'lazy'

---@type LazySpec
return {
    'stephansama/fzf-nerdfont.nvim',
    dev = true,
    lazy = true,
    build = ':FzfNerdfont generate',
    dependencies = { 'ibhagwan/fzf-lua' },
    cmd = 'FzfNerdfont',
    opts = {},
}
