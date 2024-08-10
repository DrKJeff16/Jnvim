local User = require('user_api')
local Check = User.check
local WK = User.maps.wk

local exists = Check.exists.module
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('mason') then
    return
end

local Mason = require('mason')
local Util = require('mason.api.command')

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

if not exists('mason-lspconfig') then
    return
end

local MLSP = require('mason-lspconfig')

MLSP.setup({
    ensure_installed = {
        'autotools_ls',
        'css_variables',
        'cssls',
        'cssmodules_ls',
        'mesonlsp',
        -- 'bashls',
        -- 'clangd',
        -- 'cmake',
        -- 'jsonls',
        -- 'lua_ls',
        -- 'marksman',
        -- 'pylsp',
        -- 'taplo',
        -- 'vimls',
        -- 'yamlls',
    },
    automatic_installation = false,
})

---@type KeyMapDict
local Keys = {
    ['<leader>lMo'] = { Util.Mason, desc('Open Mason UI') },
    ['<leader>lML'] = { Util.MasonLog, desc('Mason Log') },
    ['<leader>lMu'] = { Util.MasonUpdate, desc('Update Mason') },
}
---@type RegKeysNamed
local Names = {
    ['<leader>lM'] = { group = '+Mason' },
}

if WK.available() then
    map_dict(Names, 'wk.register', false, 'n')
end
map_dict(Keys, 'wk.register', false, 'n')
