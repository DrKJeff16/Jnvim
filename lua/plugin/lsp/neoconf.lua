---@module 'user_api.types.lsp'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_num = Check.value.is_num
local notify = User.util.notify.notify

if not exists('neoconf') then
    return
end

local Lspconfig = require('lspconfig')

if is_num(neoconf_configured) and neoconf_configured == 1 then
    notify("Neoconf can't be re-sourced.", 'error', {
        title = 'NeoConf',
        hide_from_history = true,
        timeout = 250,
    })
    return
else
    _G.neoconf_configured = 1
end

local NC = require('neoconf')

NC.setup({
    -- name of the local settings files
    local_settings = '.neoconf.json',
    -- name of the global settings file in your Neovim config directory
    global_settings = 'neoconf.json',
    -- import existing settings from other plugins
    import = {
        vscode = true, -- local .vscode/settings.json
        coc = false, -- global/local coc-settings.json
        nlsp = false, -- global/local nlsp-settings.nvim json settings
    },
    -- send new configuration to lsp clients when changing json settings
    live_reload = true,
    -- set the filetype to jsonc for settings files, so you can use comments
    -- make sure you have the jsonc treesitter parser installed!
    filetype_jsonc = true,
    plugins = {
        -- configures lsp clients with settings in the following order:
        -- - lua settings passed in lspconfig setup
        -- - global json settings
        -- - local json settings
        lspconfig = {
            enabled = true,
        },
        -- configures jsonls to get completion in .nvim.settings.json files
        jsonls = {
            enabled = true,
            -- only show completion in json settings for configured lsp servers
            configured_servers_only = true,
        },
        -- configures lua_ls to get completion of lspconfig server settings
        lua_ls = {
            -- by default, lua_ls annotations are only enabled in your neovim config directory
            enabled_for_neovim_config = true,
            -- explicitely enable adding annotations. Mostly relevant to put in your local .nvim.settings.json file
            enabled = true,
        },
    },
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
