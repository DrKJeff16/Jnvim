return {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'package.json', '.git' },

    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = true,
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
