---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('neorg') then
    return
end

local Neorg = require('neorg')

Neorg.setup({
    load = {
        ['core.defaults'] = {},
        ['core.ui'] = {},
        ['core.queries.native'] = {},
        ['core.autocommands'] = {},
        ['core.looking-glass'] = {},
        ['core.neorgcmd'] = {
            config = {
                defaults = { 'return' },
                load = { 'default' },
            },
        },
        ['core.neorgcmd.commands.return'] = {},
        ['core.presenter'] = {
            config = {
                zen_mode = exists('zen-mode') and 'zen-mode' or '',
            },
        },
        ['core.summary'] = {},
        ['core.mode'] = {},
        ['core.itero'] = {},
        ['core.esupports.indent'] = {},
        ['core.esupports.metagen'] = {},
        ['core.completion'] = {
            config = {
                engine = 'nvim-cmp',
                name = '[Neorg]',
            },
        },
        ['core.integrations.nvim-cmp'] = {},
        ['core.integrations.treesitter'] = {
            config = {
                configure_parsers = true,
                install_parsers = true,

                parser_configs = {
                    norg = {
                        branch = 'main',
                        files = {
                            'src/parser.c',
                            'src/scanner.cc',
                        },

                        url = 'https://github.com/nvim-neorg/tree-sitter-norg',
                    },
                    norg_meta = {
                        branch = 'main',
                        files = {
                            'src/parser.c',
                        },

                        url = 'https://github.com/nvim-neorg/tree-sitter-norg-meta',
                    },
                },
            },
        },
        ['core.highlights'] = {
            config = {
                dim = {
                    markup = {
                        inline_comment = {
                            percentage = 40,
                            reference = 'Normal',
                        },
                        verbatim = {
                            percentage = 20,
                            reference = 'Normal',
                        },
                    },

                    tags = {
                        ranged_verbatim = {
                            code_block = {
                                affect = 'background',
                                percentage = 15,
                                reference = 'Normal',
                            },
                        },
                    },
                },

                highlights = {
                    anchors = {
                        declaration = { delimiter = '+NonText' },
                        definition = { delimiter = '+NonText' },
                    },
                },
            },
        },
        ['core.concealer'] = {
            config = { icon_preset = 'varied' },
        },
        ['core.dirman'] = {
            config = {
                workspaces = {
                    personal = '~/.norg',
                    notes = '~/Documents/Notes',
                },
                index = 'index.norg',
                open_last_workspace = false,
                use_popup = true,
            },
        },
        ['core.dirman.utils'] = {},
        ['core.journal'] = {},
        ['core.qol.todo_items'] = {},
        ['core.qol.toc'] = {
            config = { close_after_use = true },
        },
        ['core.export'] = {
            config = { export_dir = '~/.norg' },
        },
        ['core.export.markdown'] = {
            config = {
                extension = 'md',
                extensions = 'all',
                mathematics = {
                    block = { ['end'] = '$$', ['start'] = '$$' },
                    inline = { ['end'] = '$', ['start'] = '$' },
                    metadata = { ['end'] = '---', ['start'] = '---' },
                },
            },
        },
        ['core.text-objects'] = {},
        ['core.keybinds'] = {
            config = {
                default_keybinds = false,
                hook = function(keybinds)
                    -- Want to move one keybind into the other? `remap_key` moves the data of the
                    -- first keybind to the second keybind, then unbinds the first keybind
                    keybinds.remap_key('norg', 'n', '<C-Space>', '<leader>nt')

                    -- Binds to move items up or down
                    keybinds.remap_event('norg', 'n', '<Up>', 'core.text-objects.item_up')
                    keybinds.remap_event('norg', 'n', '<Down>', 'core.text-objects.item_down')

                    -- text objects, these binds are available as `vaH` to "visual select around a header" or
                    -- `diH` to "delete inside a header"
                    keybinds.remap_event('norg', { 'o', 'x' }, 'iH', 'core.text-objects.textobject.heading.inner')
                    keybinds.remap_event('norg', { 'o', 'x' }, 'aH', 'core.text-objects.textobject.heading.outer')
                end,
            },
        },
    },

    lazy_loading = false,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
