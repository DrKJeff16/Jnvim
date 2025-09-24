vim.filetype.add({
    pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
})

return {
    cmd = { 'hyprls', '--stdio' },
    filetypes = { 'hyprlang' },
    root_markers = { '.git' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
