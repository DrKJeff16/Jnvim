---@module 'user_api.types.cmp'

local User = require('user_api')

local hl_dict = User.highlight.hl_from_dict

local cmp = require('cmp')
local LK = require('lspkind')

---@type FmtKindIcons
local kind_icons = {
    Class = '󰠱',
    Color = '󰏘',
    Constant = '󰏿',
    Constructor = '',
    Enum = '',
    EnumMember = '',
    Event = '',
    Field = '󰇽',
    File = '󰈙',
    Folder = '󰉋',
    Function = '󰊕',
    Interface = '',
    Keyword = '󰌋',
    Method = '󰆧',
    Module = '',
    Operator = '󰆕',
    Property = '󰜢',
    Reference = '',
    Snippet = '',
    Struct = '',
    Text = '',
    TypeParameter = '󰅲',
    Unit = '',
    Value = '󰎠',
    Variable = '󰂡',
}

---@type FmtKindIcons
local kind_codicons = {
    Class = '  ',
    Color = '  ',
    Constant = '  ',
    Constructor = '  ',
    Enum = '  ',
    EnumMember = '  ',
    Event = '  ',
    Field = '  ',
    File = '  ',
    Folder = '  ',
    Function = '  ',
    Interface = '  ',
    Keyword = '  ',
    Method = '  ',
    Module = '  ',
    Operator = '  ',
    Property = '  ',
    Reference = '  ',
    Snippet = '  ',
    Struct = '  ',
    Text = '  ',
    TypeParameter = '  ',
    Unit = '  ',
    Value = '  ',
    Variable = '  ',
}

---@type HlDict
local extra_hls = {
    PmenuSel = { bg = '#282C34', fg = 'NONE' },
    Pmenu = { fg = '#C5CDD9', bg = '#22252A' },

    CmpItemAbbrDeprecated = { bg = '#7E8294', fg = 'NONE', strikethrough = true },
    CmpItemAbbrMatch = { fg = '#82AAFF', bg = 'NONE', bold = true },
    CmpItemAbbrMatchFuzzy = { fg = '#82AAFF', bg = 'NONE', bold = true },
    CmpItemMenu = { fg = '#C792EA', bg = 'NONE', italic = true },

    CmpItemKindField = { fg = '#EED8DA', bg = '#B5585F' },
    CmpItemKindProperty = { fg = '#EED8DA', bg = '#B5585F' },
    CmpItemKindEvent = { fg = '#EED8DA', bg = '#B5585F' },

    CmpItemKindText = { fg = '#C3E88D', bg = '#A079A4' },
    CmpItemKindEnum = { fg = '#C3E88D', bg = '#A079A4' },
    CmpItemKindKeyword = { fg = '#C3E88D', bg = '#A079A4' },

    CmpItemKindConstant = { fg = '#FFE082', bg = '#6B9B68' },
    CmpItemKindConstructor = { fg = '#FFE082', bg = '#6B9B68' },
    CmpItemKindReference = { fg = '#FFE082', bg = '#6B9B68' },

    CmpItemKindFunction = { fg = '#EADFF0', bg = '#A377BF' },
    CmpItemKindStruct = { fg = '#EADFF0', bg = '#A377BF' },
    CmpItemKindClass = { fg = '#EADFF0', bg = '#A377BF' },
    CmpItemKindModule = { fg = '#EADFF0', bg = '#A377BF' },
    CmpItemKindOperator = { fg = '#EADFF0', bg = '#A377BF' },

    CmpItemKindVariable = { fg = '#C5CDD9', bg = '#5E6274' },
    CmpItemKindFile = { fg = '#C5CDD9', bg = '#5E6274' },

    CmpItemKindUnit = { fg = '#F5EBD9', bg = '#845939' },
    CmpItemKindSnippet = { fg = '#F5EBD9', bg = '#845939' },
    CmpItemKindFolder = { fg = '#F5EBD9', bg = '#845939' },

    CmpItemKindMethod = { fg = '#DDE5F5', bg = '#6C8ED4' },
    CmpItemKindValue = { fg = '#DDE5F5', bg = '#6C8ED4' },
    CmpItemKindEnumMember = { fg = '#DDE5F5', bg = '#6C8ED4' },

    CmpItemKindInterface = { fg = '#D8EEEB', bg = '#58B5A8' },
    CmpItemKindColor = { fg = '#D8EEEB', bg = '#58B5A8' },
    CmpItemKindTypeParameter = { fg = '#D8EEEB', bg = '#58B5A8' },
}

---@type CmpKindMod
local Kinds = {
    kind_icons = kind_icons,
    kind_codicons = kind_codicons,
    formatting = {
        expandable_indicator = true,
        fields = { 'kind', 'abbr' },
        format = function(entry, vim_item)
            vim_item.kind = kind_codicons[vim_item.kind] or ''
            return vim_item
        end,
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
    },
    view = {
        entries = {
            name = 'custom',
            selection_order = 'top_down',
        },
        docs = { auto_open = true },
    },
    vscode = function()
        ---@type HlDict
        local vscode_hls = {
            -- gray
            CmpItemAbbrDeprecated = { bg = 'NONE', strikethrough = true, fg = '#808080' },
            -- blue
            CmpItemAbbrMatch = { bg = 'NONE', fg = '#569CD6' },
            CmpItemAbbrMatchFuzzy = { link = 'CmpIntemAbbrMatch' },
            -- light blue
            CmpItemKindVariable = { bg = 'NONE', fg = '#9CDCFE' },
            CmpItemKindInterface = { link = 'CmpItemKindVariable' },
            CmpItemKindText = { link = 'CmpItemKindVariable' },
            -- pink
            CmpItemKindFunction = { bg = 'NONE', fg = '#C586C0' },
            CmpItemKindMethod = { link = 'CmpItemKindFunction' },
            -- front
            CmpItemKindKeyword = { bg = 'NONE', fg = '#D4D4D4' },
            CmpItemKindProperty = { link = 'CmpItemKindKeyword' },
            CmpItemKindUnit = { link = 'CmpItemKindKeyword' },
        }

        hl_dict(vscode_hls)
    end,
    extra_hls = extra_hls,
    hilite = function() hl_dict(extra_hls) end,
}

return Kinds

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
