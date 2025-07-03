---@meta

---@alias CpcSubMod.Variant ('frappe'|'latte'|'macchiato'|'mocha')
---@alias OD.Variant ('dark'|'darker'|'cool'|'deep'|'warm'|'warmer'|'light')
---@alias NFoxSubMod.Variant ('nightfox'|'carbonfox'|'dayfox'|'dawnfox'|'duskfox'|'nordfox'|'terafox')
---@alias VSCodeSubMod.Variant ('dark'|'light')
---@alias DraculaSubMod.Variant ('dracula'|'dracula-soft')
---@alias TNSubMod.Variant ('night'|'moon'|'day')
---@alias KanagawaSubMod.Variant ('dragon'|'wave'|'lotus')

---@class NFoxSubMod.Variants
---@field [1] 'carbonfox'
---@field [2] 'nightfox'
---@field [3] 'dawnfox'
---@field [4] 'dayfox'
---@field [5] 'duskfox'
---@field [6] 'nordfox'
---@field [7] 'terafox'

---@class DraculaSubMod.Variants
---@field [1] 'dracula'
---@field [2] 'dracula-soft'

---@class KanagawaSubMod.Variants
---@field [1] 'dragon'
---@field [2] 'wave'
---@field [3] 'lotus'

---@class TNSubMod.Variants
---@field [1] 'night'
---@field [2] 'moon'
---@field [3] 'day'

---@class CpcSubMod.Variants
---@field [1] 'frappe'
---@field [2] 'macchiato'
---@field [3] 'mocha'
---@field [4] 'latte'

---@alias OD.Diagnostics table<'darker'|'undercurl'|'background', boolean>

---@class OD
---@field style? OD.Variant
---@field transparent? boolean
---@field term_colors? boolean
---@field ending_tildes? boolean
---@field cmp_itemkind_reverse? boolean
---@field toggle_style_key? nil|string
---@field toggle_style_list? string[]
---@field code_style? table<string, string>
---@field lualine? table
---@field colors? table
---@field highlights? table
---@field diagnostics? OD.Diagnostics

--- A loadable color schemes table
---
--- ## Fields
--- - `variants`: An optional string array displaying the variants of said colorscheme.
---             **NOTE: Need to check if it exists**
--- - `mod_cmd`: A **protected** string to pass to `vim.cmd`. It **MUST** look like `'colorscheme ...'`
--- - `setup`: If the colorscheme is found (either as a Lua module or a `vim.g` variable)
---          it becomes a function to setup and set the colorscheme.
---          Otherwise it defaults to `nil`
---
--- If the colorscheme is not a lua plugin, use `vim.g` as a check instead
---@class CscSubMod
---@field setup fun(self: CscSubMod, variant: string?, transparent: boolean?, override: table?)
---@field valid fun(): boolean
---@field variants? string[]
---@field mod_cmd string
---@field new fun(O: table?): CscSubMod|table

---@class TNSubMod: CscSubMod
---@field setup fun(self: TNSubMod, variant: TNSubMod.Variant?, transparent: boolean?, override: table?)
---@field variants? TNSubMod.Variants
---@field new fun(O: table?): TNSubMod|table

---@see CscSubMod
--- A `CscSubMod` variant but for the `onedark.nvim` colorscheme
---@class KanagawaSubMod: CscSubMod
---@field setup fun(self: KanagawaSubMod, variant: KanagawaSubMod.Variant?, transparent: boolean?, override: table|KanagawaConfig?)|nil
---@field variants KanagawaSubMod.Variants
---@field new fun(O: table?): KanagawaSubMod|table

---@see CscSubMod
--- A `CscSubMod` variant but for the `onedark.nvim` colorscheme
---@class ODSubMod: CscSubMod
---@field setup fun(self: ODSubMod, variant: OD.Variant?, transparent: boolean?, override: table|OD?)
---@field new fun(O: table?): ODSubMod|table
---@field variants OD.Variant[]

---@see CscSubMod
--- A `CscSubMod` variant but for the `dracula` colorscheme
---@class DraculaSubMod: CscSubMod
---@field variants DraculaSubMod.Variants
---@field setup fun(self: DraculaSubMod, variant: DraculaSubMod.Variant?, transparent: boolean?, override: table?)
---@field valid fun(): boolean
---@field new fun(O: table?): table|DraculaSubMod
---@field mod_cmd string

---@see CscSubMod
--- A `CscSubMod` variant but for the `catppuccin.nvim` colorscheme
---@class CpcSubMod: CscSubMod
---@field variants CpcSubMod.Variants
---@field setup fun(self: CpcSubMod, variant: CpcSubMod.Variant?, transparent: boolean?, override: table|CatppuccinOptions?)
---@field new fun(O: table?): table|CpcSubMod

---@see CscSubMod
--- A `CscSubMod` variant but for the `nightfox.nvim` colorscheme
---@class NFoxSubMod: CscSubMod
---@field variants NFoxSubMod.Variants
---@field setup fun(self: NFoxSubMod, variant: NFoxSubMod.Variant?, transparent: boolean?, override: table?)
---@field new fun(O: table?): table|NFoxSubMod

---@see CscSubMod
--- A `CscSubMod` variant but for the `vscode` colorscheme
---@class VSCodeSubMod: CscSubMod
---@field variants (VSCodeSubMod.Variant)[]
---@field setup fun(self: VSCodeSubMod, variant: VSCodeSubMod.Variant?, transparent: boolean?, override: table?)
---@field new fun(O: table?): table|VSCodeSubMod
---override: table?)

---@alias AllColorSubMods
---|CscSubMod
---|CpcSubMod
---|DraculaSubMod
---|ODSubMod
---|NFoxSubMod
---|VSCodeSubMod

---@alias AllCsc
---|'catppuccin'
---|'dracula'
---|'gloombuddy'
---|'gruvbox'
---|'kanagawa'
---|'molokai'
---|'nightfox'
---|'oak'
---|'onedark'
---|'space_vim_dark'
---|'spaceduck'
---|'spacemacs'
---|'tokyonight'
---|'vscode'

--- A table for each **explicitly** configured colorscheme
---
--- ## Description
--- The colorschemes must comply with the `CscSubMod` type specifications
---
---@class CscMod
---@field OPTIONS (AllCsc)[]
---@field catppuccin CpcSubMod
---@field dracula DraculaSubMod
---@field gloombuddy CscSubMod
---@field gruvbox CscSubMod
---@field kanagawa KanagawaSubMod
---@field molokai CscSubMod
---@field nightfox NFoxSubMod
---@field oak CscSubMod
---@field onedark ODSubMod
---@field space_vim_dark CscSubMod
---@field spaceduck CscSubMod
---@field spacemacs CscSubMod
---@field tokyonight CscSubMod
---@field vscode CscSubMod
---@field new fun(O: table?): CscMod|table|fun(color: string?, ...)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
