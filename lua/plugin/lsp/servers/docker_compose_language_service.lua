return {
    cmd = { 'docker-compose-langserver', '--stdio' },
    filetypes = { 'yaml.docker-compose' },
    root_markers = { 'docker-compose.yaml', 'docker-compose.yml', 'compose.yaml', 'compose.yml' },
    settings = {},
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
