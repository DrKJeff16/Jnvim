---@type vim.lsp.ClientConfig
return {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'markdown.mdx' },
    root_markers = { '.git', '.marksman.toml' },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
