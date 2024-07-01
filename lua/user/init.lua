---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Types = require('user.types') ---@see User.Types
local Check = require('user.check') ---@see User.Check

--- Set the default values for this table on startup
if not Check.value.is_tbl(ACTIVATION_FLAGS) or Check.value.empty(ACTIVATION_FLAGS) then
    --- An extendable that sets the flags to indicate
    ---@type User.ActivationFlags
    _G.ACTIVATION_FLAGS = {
        autocmds = {
            jeffs_defaults = false,
        },
        plugins = {
            essentials = {
                startuptime = false,
                hover = false,
                which_key = true,
                luarocks = true,
                mini = true,
                scope = true,
                plenary = true,
                notify = true,
                nvim_web_devicons = true,
            },
            colorschemes = {
                onedark = true,
                catppuccin = true,
                tokyonight = true,
                nightfox = true,
                gloombuddy = true,
                oak = true,
                colorbuddy = true,
                spaceduck = true,
                dracula = true,
                space_vim_dark = true,
                molokai = true,
                spacemacs = true,
            },
            editing = {
                persistence = false,
                persisted = true,
                comment = true,
                endwise = true,
                todo_comments = true,
                autopairs = true,
                template = false,

                conflicting = {
                    { 'persistence', 'persisted' },
                },
            },
            completion = {
                cmp = true,
                luasnip = true,
                vlime = true,
                coc = false,

                conflicting = {
                    { 'cmp', 'coc' },
                },
            },
            lsp = {
                lspconfig = true,
                schemastore = true,
                lazydev = true,
                neoconf = true,
                clangd = false,
                inc_rename = false,
            },
            ui = {
                lualine = true,
                galaxyline = false,
                noice = false,
                bufferline = true,
                barbar = false,
                ibl = true,
                rainbow_delimiters = true,
                nvim_tree = true,
                neo_tree = false,
                colorful_winsep = false,
                hicolors = true,
                toggleterm = true,
                comment_box = false,
                dashboard = false,
                startup = false,
                alpha = false,

                conflicting = {
                    { 'lualine', 'galaxyline' },
                    { 'nvim_tree', 'neo_tree' },
                    { 'alpha', 'dashboard', 'startup' },
                },
            },
            utils = { mkdp = false },
            syntax = {
                codeowners = true,
                doxygen_toolkit = false,
            },
            telescope = {
                telescope = true,
                file_browser = true,
                fzf_native = false,
                project = true,
            },
            treesitter = {
                ts = true,
                context = true,
                commentstring = true,
                textobjects = true,
            },
            neorg = {
                neorg = true,
                zen_mode = true,
            },
            vcs = {
                fugitive = true,
                gitsigns = true,
                diffview = false,
                lazygit = false,
            },
        },
    }
end

---@type User
local M = {
    types = require('user.types'),
    util = require('user.util'),
    check = require('user.check'),
    maps = require('user.maps'),
    highlight = require('user.highlight'),
    opts = require('user.opts'),
    distro = require('user.distro'),
    update = require('user.update'),
    commands = require('user.commands'):new(),

    ---@param opts? User.ActivationFlags
    setup = function(opts)
        _G.ACTIVATION_FLAGS = (Check.value.is_tbl(opts) and not Check.value.empty(opts))
                and vim.tbl_extend('keep', opts, ACTIVATION_FLAGS)
            or ACTIVATION_FLAGS
    end,
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
