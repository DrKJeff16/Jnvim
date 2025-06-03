local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local desc = User.maps.kmap.desc

if not exists('mason') then
    return
end

User:register_plugin('plugin.lsp.mason')

local Mason = require('mason')
local MUtil = require('mason.api.command')

Mason.setup({
    install_root_dir = vim.fn.stdpath('state') .. '/mason',

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

    ui = {
        ---@since 1.0.0
        -- Whether to automatically check for new versions when opening the :Mason window.
        check_outdated_packages_on_open = true,

        ---@since 1.0.0
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = 'rounded',

        ---@since 1.0.0
        -- Width of the window. Accepts:
        -- - Integer greater than 1 for fixed width.
        -- - Float in the range of 0-1 for a percentage of screen width.
        width = 0.8,

        ---@since 1.0.0
        -- Height of the window. Accepts:
        -- - Integer greater than 1 for fixed height.
        -- - Float in the range of 0-1 for a percentage of screen height.
        height = 0.9,

        icons = {
            ---@since 1.0.0
            -- The list icon to use for installed packages.
            package_installed = '◍',
            ---@since 1.0.0
            -- The list icon to use for packages that are installing, or queued for installation.
            package_pending = '◍',
            ---@since 1.0.0
            -- The list icon to use for packages that are not installed.
            package_uninstalled = '◍',
        },

        keymaps = {
            ---@since 1.0.0
            -- Keymap to expand a package
            toggle_package_expand = '<CR>',
            ---@since 1.0.0
            -- Keymap to install the package under the current cursor position
            install_package = 'i',
            ---@since 1.0.0
            -- Keymap to reinstall/update the package under the current cursor position
            update_package = 'u',
            ---@since 1.0.0
            -- Keymap to check for new version for the package under the current cursor position
            check_package_version = 'c',
            ---@since 1.0.0
            -- Keymap to update all installed packages
            update_all_packages = 'U',
            ---@since 1.0.0
            -- Keymap to check which installed packages are outdated
            check_outdated_packages = 'C',
            ---@since 1.0.0
            -- Keymap to uninstall a package
            uninstall_package = 'X',
            ---@since 1.0.0
            -- Keymap to cancel a package installation
            cancel_installation = '<C-c>',
            ---@since 1.0.0
            -- Keymap to apply language filter
            apply_language_filter = '<C-f>',
            ---@since 1.1.0
            -- Keymap to toggle viewing package installation log
            toggle_package_install_log = '<CR>',
            ---@since 1.8.0
            -- Keymap to toggle the help view
            toggle_help = 'g?',
        },
    },
})

---@type KeyMapDict|RegKeysNamed
local Keys = {
    ['<leader>lM'] = { group = '+Mason' },

    ['<leader>lMo'] = { MUtil.Mason, desc('Open Mason UI') },
    ['<leader>lML'] = { MUtil.MasonLog, desc('Mason Log') },
    ['<leader>lMu'] = { MUtil.MasonUpdate, desc('Update Mason') },
}

vim.schedule(function()
    local Keymaps = require('config.keymaps')
    Keymaps:setup({ n = Keys })
end)

if not exists('mason-lspconfig') then
    return
end

local MLSP = require('mason-lspconfig')

MLSP.setup({
    ensure_installed = {
        -- 'autotools_ls',
        -- 'bashls',
        -- 'clangd',
        -- 'cmake',
        -- 'css_variables',
        -- 'cssls',
        -- 'cssmodules_ls',
        -- 'jsonls',
        -- 'lua_ls',
        -- 'marksman',
        -- 'mesonlsp',
        -- 'pylsp',
        -- 'taplo',
        -- 'vimls',
        -- 'yamlls',
    },

    automatic_installation = false,

    automatic_enable = false,
})
