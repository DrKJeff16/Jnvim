local exists = require('user_api.check.exists').module

---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class VagueSubMod
local Vague = {}

---@class VagueSubMod.Variants
Vague.variants = {}

Vague.mod_cmd = 'silent! colorscheme vague'

---@return boolean
function Vague.valid()
    return exists('vague')
end

function Vague.setup(_, _, overrides)
    require('vague').setup(vim.tbl_deep_extend('keep', overrides or {}, {
        transparent = false, -- don't set background
        -- disable bold/italic globally in `style`
        bold = true,
        italic = true,
        style = {
            -- "none" is the same thing as default. But "italic" and "bold" are also valid options
            boolean = 'bold',
            number = 'none',
            float = 'none',
            error = 'bold',
            comments = 'none',
            conditionals = 'none',
            functions = 'none',
            headings = 'bold',
            operators = 'none',
            strings = 'none',
            variables = 'none',

            -- keywords
            keywords = 'bold',
            keyword_return = 'bold',
            keywords_loop = 'bold',
            keywords_label = 'bold',
            keywords_exception = 'bold',

            -- builtin
            builtin_constants = 'bold',
            builtin_functions = 'none',
            builtin_types = 'bold',
            builtin_variables = 'none',
        },
        -- plugin styles where applicable
        -- make an issue/pr if you'd like to see more styling options!
        plugins = {
            cmp = { match = 'bold', match_fuzzy = 'bold' },
            dashboard = { footer = 'none' },
            lsp = {
                diagnostic_error = 'bold',
                diagnostic_hint = 'none',
                diagnostic_info = 'bold',
                diagnostic_ok = 'none',
                diagnostic_warn = 'bold',
            },
            neotest = { focused = 'bold', adapter_name = 'bold' },
            telescope = { match = 'bold' },
        },

        -- Override highlights or add new highlights
        -- on_highlights = function(highlights, colors) end,

        -- Override colors
        colors = {
            bg = '#141415',
            inactiveBg = '#1c1c24',
            fg = '#cdcdcd',
            floatBorder = '#878787',
            line = '#252530',
            comment = '#606079',
            builtin = '#b4d4cf',
            func = '#c48282',
            string = '#e8b589',
            number = '#e0a363',
            property = '#c3c3d5',
            constant = '#aeaed1',
            parameter = '#bb9dbd',
            visual = '#333738',
            error = '#d8647e',
            warning = '#f3be7c',
            hint = '#7e98e8',
            operator = '#90a0b5',
            keyword = '#6e94b2',
            type = '#9bb4bc',
            search = '#405065',
            plus = '#7fa563',
            delta = '#f3be7c',
        },
    }))

    vim.cmd(Vague.mod_cmd)
end

return Vague
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
