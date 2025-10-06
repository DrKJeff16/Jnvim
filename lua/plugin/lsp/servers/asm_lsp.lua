---@type vim.lsp.ClientConfig
return {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'vmasm' },
    root_markers = { '.asm-lsp.toml', '.git' },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
