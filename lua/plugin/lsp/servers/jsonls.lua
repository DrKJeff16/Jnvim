return {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = { provideFormatter = true },
    root_markers = { '.git' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
