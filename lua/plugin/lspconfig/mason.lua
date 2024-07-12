---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('mason') then
    return
end

local Mason = require('mason')

Mason.setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
    },

    install_root_dir = vim.fn.stdpath('data') .. '/mason',

    PATH = 'prepend',

    registries = {
        'github:mason-org/mason-registry',
    },

    providers = {
        'mason.providers.registry-api',
        'mason.providers.client',
    },

    github = {
        -- The template URL to use when downloading assets from GitHub.
        -- The placeholders are the following (in order):
        -- 1. The repository (e.g. "rust-lang/rust-analyzer")
        -- 2. The release version (e.g. "v0.3.0")
        -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
        download_url_template = 'https://github.com/%s/releases/download/%s/%s',
    },
})

if not exists('mason-lspconfig') then
    return
end

local MLSP = require('mason-lspconfig')

MLSP.setup({
    ensure_installed = {
        'lua_ls',
        'jsonls',
        -- 'bashls',
        -- 'pylsp',
        -- 'taplo',
        -- 'vimls',
        -- 'yamlls',
        -- 'mesonlsp',
        -- 'marksman',
        -- 'cssls',
        -- 'cssmodules_ls',
        -- 'css_variables',
        -- 'cmake',
        -- 'clangd',
        -- 'autotools_ls',
        -- 'pkgbuild_language_server',
    },
    automatic_installation = false,
})
