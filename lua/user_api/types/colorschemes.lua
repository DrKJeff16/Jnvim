---@meta

---@alias CpcSubMod.Variants ('frappe'|'latte'|'macchiato'|'mocha')
---@alias NFoxSubMod.Variants ('nightfox'|'carbonfox'|'dayfox'|'dawnfox'|'duskfox'|'nordfox'|'terafox')
---@alias VSCodeSubMod.Variants ('dark'|'light')
---@alias DraculaSubMod.Variants ('dracula'|'dracula-soft')

---@alias OD.Variant ('dark'|'darker'|'cool'|'deep'|'warm'|'warmer'|'light')
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

---@class TN.Variants
---@field [1] 'night'
---@field [2] 'moon'
---@field [3] 'day'

---@class KanagawaSubMod.Variants
---@field [1] 'dragon'
---@field [2] 'wave
---@field [3] 'lotus'

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

---@see CscSubMod
--- A `CscSubMod` variant but for the `onedark.nvim` colorscheme
---@class KanagawaSubMod: CscSubMod
---@field setup fun(self: KanagawaSubMod, variant: KanagawaSubMod.Variants, transparent: boolean?, override: table|KanagawaConfig?)|nil
---@field new fun(O: table?): KanagawaSubMod|table
---@field variants KanagawaSubMod.Variants

---@see CscSubMod
--- A `CscSubMod` variant but for the `onedark.nvim` colorscheme
---@class ODSubMod: CscSubMod
---@field setup fun(self: ODSubMod, variant: OD.Variant?, transparent: boolean?, override: table|OD?)
---@field new fun(O: table?): ODSubMod|table
---@field variants OD.Variant[]

--- A `CscSubMod` variant but for the `dracula` colorscheme
---@class DraculaSubMod: CscSubMod
---@field variants (DraculaSubMod.Variants)[]
---@field setup fun(self: DraculaSubMod, variant: DraculaSubMod.Variants?, transparent: boolean?, override: table?)
---@field valid fun(): boolean
---@field new fun(O: table?): table|DraculaSubMod
---@field mod_cmd string

---@see CscSubMod
--- A `CscSubMod` variant but for the `catppuccin.nvim` colorscheme
---@class CpcSubMod: CscSubMod
---@field variants CpcSubMod.Variants[]
---@field setup fun(self: CpcSubMod, variant: CpcSubMod.Variants, transparent: boolean?, override: table|CatppuccinOptions?)
---@field new fun(O: table?): table|CpcSubMod

---@see CscSubMod
--- A `CscSubMod` variant but for the `nightfox.nvim` colorscheme
---@class NFoxSubMod: CscSubMod
---@field variants NFoxSubMod.Variants[]
---@field setup fun(self: NFoxSubMod, variant: NFoxSubMod.Variants?, transparent: boolean?, override: table?)
---@field new fun(O: table?): table|NFoxSubMod

---@see CscSubMod
--- A `CscSubMod` variant but for the `vscode` colorscheme
---@class VSCodeSubMod: CscSubMod
---@field variants VSCodeSubMod.Variants[]
---@field setup fun(self: VSCodeSubMod, variant: VSCodeSubMod.Variants?, transparent: boolean?, override: table?)
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
---@field OPTIONS AllCsc[]
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
---@field new fun(O: table?): CscMod|table

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
