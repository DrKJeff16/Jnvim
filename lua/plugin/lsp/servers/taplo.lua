---@type vim.lsp.ClientConfig
return {
    cmd = { 'taplo', 'lsp', 'stdio' },
    filetypes = { 'toml' },
    root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
